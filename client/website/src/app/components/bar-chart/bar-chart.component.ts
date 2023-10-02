import { Component } from '@angular/core';

@Component({
  selector: 'app-bar-chart',
  templateUrl: './bar-chart.component.html',
  styleUrls: ['./bar-chart.component.css'],
})
export class BarChartComponent {
  chartOptions = {
    title: {
      text: 'Top Countries by User Count',
      fontFamily: 'Helvetica',
      fontSize: 24,
      fontWeight: 'bold',
    },
    animationEnabled: true,
    axisY: {
      title: 'Values',
    },
    data: [
      {
        type: 'bar',
        dataPoints: [
          { label: 'Category A', y: 10 },
          { label: 'Category B', y: 20 },
          { label: 'Category C', y: 30 },
          { label: 'Category D', y: 40 },
          { label: 'Category E', y: 50 },
        ],
      },
    ],
  };
}
