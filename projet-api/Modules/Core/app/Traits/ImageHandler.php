<?php

namespace Modules\Core\app\Traits;

use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;

trait ImageHandler
{
    /**
     * Sauvegarde une image en base64
     *
     * @param string $base64Image
     * @param string $disk
     * @return string|null
     */
    protected function saveImage($base64Image, $disk = 'public')
    {
        try {
            // Vérifier si l'image est en base64
            if (preg_match('/^data:image\/(\w+);base64,/', $base64Image, $type)) {
                // Extraire le type et les données de l'image
                $imageData = substr($base64Image, strpos($base64Image, ',') + 1);
                $type = strtolower($type[1]); // jpg, png, gif

                // Vérifier si le type est valide
                if (!in_array($type, ['jpg', 'jpeg', 'gif', 'png'])) {
                    throw new \Exception('Type d\'image invalide');
                }

                // Décoder l'image
                $imageData = base64_decode($imageData);

                if ($imageData === false) {
                    throw new \Exception('Échec du décodage base64');
                }

                // Générer un nom de fichier unique
                $filename = Str::uuid() . '.' . $type;

                // Sauvegarder l'image
                Storage::disk($disk)->put($filename, $imageData);

                return $filename;
            }
            
            return null;
        } catch (\Exception $e) {
            \Log::error('Erreur lors de la sauvegarde de l\'image: ' . $e->getMessage());
            return null;
        }
    }

    /**
     * Supprime une image
     *
     * @param string $filename
     * @param string $disk
     * @return bool
     */
    protected function deleteImage($filename, $disk = 'public')
    {
        try {
            if ($filename && Storage::disk($disk)->exists($filename)) {
                return Storage::disk($disk)->delete($filename);
            }
            return false;
        } catch (\Exception $e) {
            \Log::error('Erreur lors de la suppression de l\'image: ' . $e->getMessage());
            return false;
        }
    }
}
