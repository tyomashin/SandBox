//
//  ViewController.swift
//  ChartsSample
//
//  Created by 岡崎伸也 on 2022/02/15.
//

import UIKit
import Charts

/// 参考：https://pomarano.site/ios/147/
class ViewController: UIViewController {

    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var horChart: HorizontalBarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setPieChart()
        // setChart()
    }
    
    /// 円グラフセット
    func setPieChart() {
        pieChartView.backgroundColor = .gray
        
        // グラフの中央に表示されるテキスト
        pieChartView.centerText = "個人的\n果物ランキング"
                
        // グラフの右下に表示されるテキスト
        pieChartView.chartDescription?.text = "このランキングは、今まで食べた果物の中から、\n独断と偏見のみで順位づけしています。"

        // データセット
        let entries = [
            PieChartDataEntry(value: 40.0, label: "桃"),
            PieChartDataEntry(value: 30.0, label: "梨"),
            PieChartDataEntry(value: 20.0, label: "みかん"),
            PieChartDataEntry(value: 10.0, label: "メロンメロンメロンメロン"),
            PieChartDataEntry(value: 40.0, label: "りんご")
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "")
                
        // グラフの値を％表示するかどうか
        pieChartView.usePercentValuesEnabled = true
        
        // グラフの色
        dataSet.colors = ChartColorTemplates.vordiplom()
        // dataSet.colors = [.red]
                
        // データのラベル色
        dataSet.valueTextColor = .black
        dataSet.entryLabelColor = .blue
                
        // グラフに設定
        let chartData = PieChartData(dataSet: dataSet)
        pieChartView.data = chartData
    }
    
//
//
//    /// 棒グラフセット
//    func setChart() {
//
//
////        let dataPoints = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
////        let values = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
//
//        horChart.xAxis.drawLabelsEnabled = false
//        // グリッド無効
//        horChart.xAxis.gridAntialiasEnabled = false
//
////        let entry = [
////            BarChartDataEntry(x: 1, y: 30),
////            BarChartDataEntry(x: 2, y: 20),
////            BarChartDataEntry(x: 3, y: 40),
////            BarChartDataEntry(x: 4, y: 10),
////            BarChartDataEntry(x: 5, y: 30)
////        ]
////        let set = BarChartDataSet(entries: entry, label: "Data")
//
//        let data = BarChartData()
//
//        let ds1 = BarChartDataSet(entries: [BarChartDataEntry(x: 1, y: 10)], label: "")
//        ds1.colors = [UIColor.red, UIColor.blue]
//
//        // Number formatting of Values
//        // ds1.valueFormatter = YAxisValueFormatter()
//        // ds1.valueFont = UIFont(fontType: .H6)!
//        // ds1.valueTextColor = UIColor.dark_text
//        data.addDataSet(ds1)
//        horChart.data = data
//    }
}

