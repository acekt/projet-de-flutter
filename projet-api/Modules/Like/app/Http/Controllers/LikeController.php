<?php

namespace Modules\Like\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Modules\Like\Models\Like;
use Modules\Post\Models\Post;

class LikeController extends Controller
{
    // Ajouter ou retirer un like
    public function toggleLike($postId)
    {
        // Vérifier si le post existe
        $post = Post::findOrFail($postId);

        // Rechercher un like existant
        $like = Like::where('post_id', $postId)
                    ->where('user_id', auth()->id())
                    ->first();

        if ($like) {
            // Si le like existe, on le supprime
            $like->delete();
            $message = 'Like retiré';
            $action = 'unliked';
        } else {
            // Sinon, on crée un nouveau like
            $like = $post->likes()->create([
                'user_id' => auth()->id()
            ]);
            $message = 'Post liké';
            $action = 'liked';
        }

        return response([
            'message' => $message,
            'action' => $action,
            'likes_count' => $post->likes()->count()
        ], 200);
    }
}
