<?php

namespace Modules\Core\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class ImageService
{
    /**
     * Sauvegarde une image et retourne son nom de fichier
     *
     * @param UploadedFile $image
     * @param string $path
     * @return string
     */
    public function saveImage(UploadedFile $image, string $path): string
    {
        $filename = Str::uuid() . '.' . $image->getClientOriginalExtension();
        $image->storeAs("public/{$path}", $filename);
        return $filename;
    }

    /**
     * Supprime une image
     *
     * @param string $filename
     * @param string $path
     * @return bool
     */
    public function deleteImage(string $filename, string $path): bool
    {
        return Storage::delete("public/{$path}/" . $filename);
    }

    /**
     * Retourne l'URL complète d'une image
     *
     * @param string|null $filename
     * @param string $path
     * @return string|null
     */
    public function getImageUrl(?string $filename, string $path): ?string
    {
        if (!$filename) {
            return null;
        }
        return url("storage/{$path}/" . $filename);
    }
}
