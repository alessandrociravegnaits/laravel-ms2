use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ProductApiController;
use App\Http\Controllers\Api\CategoryApiController;

Route::apiResource('products', ProductApiController::class);
Route::apiResource('categories', CategoryApiController::class);


