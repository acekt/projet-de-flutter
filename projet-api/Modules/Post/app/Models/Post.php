<?php

namespace Modules\Post\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Modules\Auth\Models\User;
use Modules\Comment\Models\Comment;
use Modules\Like\Models\Like;

class Post extends Model
{
    protected $fillable = [
        'body',
        'image',
        'user_id'
    ];

    protected $appends = [
        'image_url'
    ];

    // Relation avec l'utilisateur
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Relation avec les commentaires
    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);
    }

    // Relation avec les likes
    public function likes(): HasMany
    {
        return $this->hasMany(Like::class);
    }

    // Vérifier si l'utilisateur connecté a liké le post
    public function isLikedByUser()
    {
        if (!auth()->check()) return false;
        return $this->likes()->where('user_id', auth()->id())->exists();
    }

    // Accesseur pour l'URL de l'image
    public function getImageUrlAttribute()
    {
        if (!$this->image) {
            return null;
        }
        return url('storage/posts/' . $this->image);
    }
}
