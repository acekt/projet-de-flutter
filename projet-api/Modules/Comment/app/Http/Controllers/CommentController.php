<?php

namespace Modules\Comment\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Modules\Comment\Models\Comment;
use Modules\Post\Models\Post;

class CommentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return view('comment::index');
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('comment::create');
    }

    // Ajouter un commentaire
    public function store(Request $request, $postId)
    {
        // Vérifier si le post existe
        $post = Post::findOrFail($postId);

        $champs = $request->validate([
            'body' => 'required|string'
        ]);

        $comment = $post->comments()->create([
            'body' => $champs['body'],
            'user_id' => auth()->id()
        ]);

        return response([
            'comment' => $comment,
            'message' => 'Commentaire ajouté avec succès'
        ], 201);
    }

    /**
     * Show the specified resource.
     */
    public function show($id)
    {
        return view('comment::show');
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit($id)
    {
        return view('comment::edit');
    }

    // Modifier un commentaire
    public function update(Request $request, $id)
    {
        $comment = Comment::findOrFail($id);

        // Vérifier si l'utilisateur est le propriétaire du commentaire
        if($comment->user_id !== auth()->id()) {
            return response([
                'message' => 'Non autorisé'
            ], 403);
        }

        $champs = $request->validate([
            'body' => 'required|string'
        ]);

        $comment->update($champs);

        return response([
            'comment' => $comment,
            'message' => 'Commentaire modifié avec succès'
        ], 200);
    }

    // Supprimer un commentaire
    public function destroy($id)
    {
        $comment = Comment::findOrFail($id);

        // Vérifier si l'utilisateur est le propriétaire du commentaire
        if($comment->user_id !== auth()->id()) {
            return response([
                'message' => 'Non autorisé'
            ], 403);
        }

        $comment->delete();

        return response([
            'message' => 'Commentaire supprimé avec succès'
        ], 200);
    }
}
