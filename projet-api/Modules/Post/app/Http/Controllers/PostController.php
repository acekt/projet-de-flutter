<?php

namespace Modules\Post\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Modules\Post\Models\Post;
use Modules\Core\Services\ImageService;

class PostController extends Controller
{
    protected $imageService;

    public function __construct(ImageService $imageService)
    {
        $this->imageService = $imageService;
    }

    // Lister tous les posts
    public function index()
    {
        $posts = Post::orderBy('created_at', 'desc')
            ->with('user:id,name,image')
            ->withCount('likes')
            ->get()
            ->map(function($post) {
                $post->is_liked = $post->isLikedByUser();
                $post->image_url = $this->imageService->getImageUrl($post->image, 'posts');
                return $post;
            });

        return response([
            'posts' => $posts
        ], 200);
    }

    // Créer un post
    public function store(Request $request)
    {
        $champs = $request->validate([
            'body' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);

        // Gérer l'image si elle existe
        if ($request->hasFile('image')) {
            $champs['image'] = $this->imageService->saveImage($request->file('image'), 'posts');
        }

        $post = auth()->user()->posts()->create($champs);
        $post->image_url = $this->imageService->getImageUrl($post->image, 'posts');

        return response([
            'post' => $post,
            'message' => 'Post créé avec succès'
        ], 201);
    }

    // Afficher un post
    public function show($id)
    {
        $post = Post::where('id', $id)
            ->with('user:id,name,image')
            ->with(['comments' => function($query) {
                $query->with('user:id,name,image')
                    ->orderBy('created_at', 'desc');
            }])
            ->withCount('likes')
            ->first();

        if (!$post) {
            return response([
                'message' => 'Post non trouvé'
            ], 404);
        }

        $post->is_liked = $post->isLikedByUser();
        $post->image_url = $this->imageService->getImageUrl($post->image, 'posts');

        return response([
            'post' => $post
        ], 200);
    }

    // Modifier un post
    public function update(Request $request, $id)
    {
        $post = Post::findOrFail($id);

        // Vérifier si l'utilisateur est le propriétaire du post
        if($post->user_id !== auth()->id()) {
            return response([
                'message' => 'Non autorisé'
            ], 403);
        }

        $champs = $request->validate([
            'body' => 'required|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048'
        ]);

        // Gérer l'image si elle existe
        if ($request->hasFile('image')) {
            // Supprimer l'ancienne image si elle existe
            if ($post->image) {
                $this->imageService->deleteImage($post->image, 'posts');
            }

            $champs['image'] = $this->imageService->saveImage($request->file('image'), 'posts');
        }

        $post->update($champs);
        $post->image_url = $this->imageService->getImageUrl($post->image, 'posts');

        return response([
            'post' => $post,
            'message' => 'Post modifié avec succès'
        ], 200);
    }

    // Supprimer un post
    public function destroy($id)
    {
        $post = Post::findOrFail($id);

        // Vérifier si l'utilisateur est le propriétaire du post
        if($post->user_id !== auth()->id()) {
            return response([
                'message' => 'Non autorisé'
            ], 403);
        }

        // Supprimer l'image si elle existe
        if ($post->image) {
            $this->imageService->deleteImage($post->image, 'posts');
        }

        $post->delete();

        return response([
            'message' => 'Post supprimé avec succès'
        ], 200);
    }
}
