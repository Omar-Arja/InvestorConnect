import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-bar-chart',
  templateUrl: './bar-chart.component.html',
  styleUrls: ['./bar-chart.component.css'],
})
export class BarChartComponent {
  @Input() chartData: any[] = [];

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
        dataPoints: this.chartData,
      },
    ],
  };
}
