<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\DB;
use Illuminate\Http\Request;
use App\Models\Swipe;
use App\Models\MatchedProfile;
use App\Models\Message;
use App\Models\InvestorProfile;
use App\Models\StartupProfile;
use App\Models\User;
use App\Models\Usertype;

class AnalyticsController extends Controller
{
    public function getData() {
        $total_swipes_right = $this->getTotalSwipesRight();
        $total_matches = $this->getTotalMatches();
        $total_messages = $this->getTotalMessages();
        $top_locations_data = $this->getTopLocationsData();
        $users_chart_data = $this->getUsersChartData();
        
        $data = [
            "total_swipes_right" => $total_swipes_right,
            "total_matches" => $total_matches,
            "total_messages" => $total_messages,
            "top_locations_data" => $top_locations_data,
            "users_chart_data" => $users_chart_data,
        ];

        return response()->json([
            "status" => "success",
            "data" => $data,
        ]);
    }

    // local functions
    public function getTotalSwipesRight() {
        $swipes_right = Swipe::where('direction', 'right')->count();
        $total_matched_profiles = MatchedProfile::count();
        $total_swipes_right = $swipes_right + $total_matched_profiles * 2;

        return $total_swipes_right;
    }

    public function getTotalMatches() {
        $total_matches = MatchedProfile::count();

        return $total_matches;
    }

    public function getTotalMessages() {
        $total_messages = Message::count();

        return $total_messages;
    }

    public function getTopLocationsData() {
        $top_locations = DB::table('investor_profiles')
            ->select('location', DB::raw('COUNT(*) as user_count'))
            ->groupBy('location')
            ->unionAll(DB::table('startup_profiles')->select('location', DB::raw('COUNT(*) as user_count'))->groupBy('location'))
            ->groupBy('location')
            ->orderByDesc('user_count')
            ->limit(5)
            ->get();

        return $top_locations;
    }

    public function getTotalInvestors() {
        $total_investors = InvestorProfile::count();

        return $total_investors;
    }

    public function getTotalStartups() {
        $total_startups = StartupProfile::count();

        return $total_startups;
    }

    public function getTotalPending() {
        $total_pending = User::where('usertype_id', Usertype::where('name', 'pending')->first()->id)->count();

        return $total_pending;
    }

    public function getUsersChartData() {
    $total_investors = $this->getTotalInvestors();
    $total_startups = $this->getTotalStartups();

    $users_chart_data = [
        [
            "label" => "Startups",  
            "value" => $total_startups,
        ],
        [
            "label" => "Investors",
            "value" => $total_investors,
        ],
        [
            "label" => "Pending",
            "value" => $this->getTotalPending(),
        ]
    ];

    return $users_chart_data;
}
}
