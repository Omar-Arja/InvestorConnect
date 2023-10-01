<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Support\Facades\Auth;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        if (Auth::user()->usertype_name !== 'admin') {
            return response()->json([
                'message' => 'You are not authorized to access this resource',
            ], 403);
        }

        return $next($request);
    }
}
