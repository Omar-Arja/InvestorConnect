import { Component, OnInit } from '@angular/core';
import { ApiService } from './../../services/api.service';

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css'],
})
export class DashboardComponent implements OnInit {
  totalSwipeRights: number = 0;
  totalMatches: number = 0;
  totalMessages: number = 0;
  topCountriesChartData: any[] = [];
  usersChartData: any[] = [];

  constructor(private apiService: ApiService) {}

  ngOnInit(): void {
    this.apiService.getDashboardData().subscribe((response) => {
      if (response.status === 'success') {
        this.totalSwipeRights = response.data.total_swipes_right;
        this.totalMatches = response.data.total_matches;
        this.totalMessages = response.data.total_messages;

        this.topCountriesChartData = response.data.top_locations_data.map(
          (item: { location: any; user_count: any }) => ({
            label: item.location,
            y: item.user_count,
          })
        );

        this.usersChartData = response.data.users_chart_data.map(
          (item: { label: any; value: any }) => ({
            label: item.label,
            y: item.value,
          })
        );
      }
    });
  }
}
