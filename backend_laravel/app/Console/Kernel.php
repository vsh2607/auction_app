<?php

namespace App\Console;

use App\Events\ProductAdded;
use App\Models\Product;
use Carbon\Carbon;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;
use Illuminate\Support\Facades\Log;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule): void
    {
        $schedule->call(function(){
    
            $products = Product::where('product_ddl', '<', Carbon::now())->where('product_status', 1)->get();
            if(count($products) > 0){
                Product::where('product_ddl', '<', Carbon::now())->where('product_status', 1)->update(['product_status' => 0]);
                ProductAdded::dispatch("Product Deadline Updated");
            }
    
        })->everySecond();
    }
    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }
}
