import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-donut-chart',
  templateUrl: './donut-chart.component.html',
  styleUrls: ['./donut-chart.component.css'],
})
export class DonutChartComponent {
  @Input() chartData: any[] = [];

  chartOptions = {
    title: {
      text: 'Users',
      fontFamily: 'Helvetica',
      fontSize: 24,
      fontWeight: 'bold',
    },
    animationEnabled: true,
    data: [
      {
        type: 'doughnut',
        indexLabel: '{label}: {y}',
        dataPoints: this.chartData,
      },
    ],
  };
}
