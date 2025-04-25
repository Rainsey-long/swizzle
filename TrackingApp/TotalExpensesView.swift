import UIKit
import Charts

class TotalExpensesView: UIView {
    
    // MARK: - Properties
    private let titleLabel = UILabel()
    private let filterButton = UIButton()
    private let chartView = BarChartView()
    
    // Chart data
    private let xAxisValues = ["0", "1", "2", "3", "4", "5"]
    private let firstSeriesData: [Double] = [150, 300, 200, 450, 380, 250]  // Green bars (expenses 1)
    private let secondSeriesData: [Double] = [100, 250, 350, 280, 420, 180]  // Brown bars (expenses 2)
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        
        setupTitleAndFilter()
        setupChartView()
    }
    
    private func setupTitleAndFilter() {
        // Title
        titleLabel.text = "Total expenses"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1.0) // #242424
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // Filter button
        let filterContainer = UIView()
        filterContainer.translatesAutoresizingMaskIntoConstraints = false
        filterContainer.layer.borderWidth = 0.5
        filterContainer.layer.borderColor = UIColor(red: 0.42, green: 0.42, blue: 0.42, alpha: 0.9).cgColor // rgba(105, 105, 105, 0.9)
        filterContainer.layer.cornerRadius = 10
        addSubview(filterContainer)
        
        let filterStack = UIStackView()
        filterStack.axis = .horizontal
        filterStack.alignment = .center
        filterStack.spacing = 2
        filterStack.translatesAutoresizingMaskIntoConstraints = false
        filterContainer.addSubview(filterStack)
        
        let weeklyLabel = UILabel()
        weeklyLabel.text = "Weekly"
        weeklyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        weeklyLabel.textColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.0) // #696969
        
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.down")
        chevronImageView.tintColor = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.0) // #696969
        chevronImageView.contentMode = .scaleAspectFit
        
        filterStack.addArrangedSubview(weeklyLabel)
        filterStack.addArrangedSubview(chevronImageView)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            filterContainer.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            filterContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            filterContainer.heightAnchor.constraint(equalToConstant: 30),
            
            filterStack.topAnchor.constraint(equalTo: filterContainer.topAnchor, constant: 5),
            filterStack.bottomAnchor.constraint(equalTo: filterContainer.bottomAnchor, constant: -5),
            filterStack.leadingAnchor.constraint(equalTo: filterContainer.leadingAnchor, constant: 10),
            filterStack.trailingAnchor.constraint(equalTo: filterContainer.trailingAnchor, constant: -10),
        ])
    }
    
    private func setupChartView() {
        // Setup chart view
        chartView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            chartView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            chartView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            chartView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            chartView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        configureChartView()
        updateChartData()
    }
    
    private func configureChartView() {
        // Chart general appearance
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = false
        chartView.maxVisibleCount = 6
        chartView.fitBars = true
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        
        // X-axis setup
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = true
        xAxis.gridColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) // #CCCCCC
        xAxis.gridLineWidth = 0.5
        xAxis.labelFont = UIFont.systemFont(ofSize: 6.3)
        xAxis.labelTextColor = .black
        xAxis.granularity = 1
        
        // Left Y-axis (hidden)
        let leftAxis = chartView.leftAxis
        leftAxis.enabled = false
        
        // Right Y-axis
        let rightAxis = chartView.rightAxis
        rightAxis.labelPosition = .outsideChart
        rightAxis.labelFont = UIFont.systemFont(ofSize: 6.3)
        rightAxis.labelTextColor = .black
        rightAxis.axisMinimum = 0
        rightAxis.gridColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) // #CCCCCC
        rightAxis.gridLineWidth = 0.5
        rightAxis.valueFormatter = YAxisValueFormatter()
    }
    
    private func updateChartData() {
        // Bar chart data entry
        var greenEntries: [BarChartDataEntry] = []
        var brownEntries: [BarChartDataEntry] = []
        
        for i in 0..<xAxisValues.count {
            greenEntries.append(BarChartDataEntry(x: Double(i), y: firstSeriesData[i]))
            brownEntries.append(BarChartDataEntry(x: Double(i), y: secondSeriesData[i]))
        }
        
        // Green data set
        let greenDataSet = BarChartDataSet(entries: greenEntries, label: "Green Series")
        greenDataSet.colors = [UIColor(red: 0.61, green: 0.87, blue: 0.69, alpha: 1.0)] // #9CDFAF
        greenDataSet.valueTextColor = .clear
        greenDataSet.highlightEnabled = false
        
        // Brown data set
        let brownDataSet = BarChartDataSet(entries: brownEntries, label: "Brown Series")
        brownDataSet.colors = [UIColor(red: 0.68, green: 0.44, blue: 0.29, alpha: 1.0)] // #AE6F49
        brownDataSet.valueTextColor = .clear
        brownDataSet.highlightEnabled = false
        
        // Group bars
        let groupSpace = 0.3
        let barSpace = 0.05
        let barWidth = 0.3
        
        let groupCount = xAxisValues.count
        let startX = 0.0
        let endX = startX + Double(groupCount)
        
        let data = BarChartData(dataSets: [greenDataSet, brownDataSet])
        data.barWidth = barWidth
        
        // Set the group spacing
        data.groupBars(fromX: startX, groupSpace: groupSpace, barSpace: barSpace)
        
        // Set x-axis values
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisValues)
        chartView.xAxis.axisMinimum = startX
        chartView.xAxis.axisMaximum = endX
        
        chartView.data = data
        chartView.animate(yAxisDuration: 1.0)
    }
}

// Custom formatter for Y-axis labels
class YAxisValueFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))"
    }
}
