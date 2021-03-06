//
//  XAxisRendererRadarChart.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

open class XAxisRendererRadarChart: XAxisRenderer
{
    @objc open weak var chart: RadarChartView?
    
    @objc public init(viewPortHandler: ViewPortHandler, xAxis: XAxis?, chart: RadarChartView)
    {
        super.init(viewPortHandler: viewPortHandler, xAxis: xAxis, transformer: nil)
        
        self.chart = chart
    }
    
    open override func renderAxisLabels(context: CGContext)
    {
        guard let
            xAxis = axis as? XAxis,
            let chart = chart
            else { return }
        
        if !xAxis.isEnabled || !xAxis.isDrawLabelsEnabled
        {
            return
        }
        
        let labelFont = xAxis.labelFont
        let labelTextColor = xAxis.labelTextColor
        let subLabelFont = xAxis.subLabelFont
        let subLabelTextColor = xAxis.subLabelTextColor
        let labelRotationAngleRadians = xAxis.labelRotationAngle.RAD2DEG
        let drawLabelAnchor = CGPoint(x: 0.5, y: 0.25)
        
        let sliceangle = chart.sliceAngle
        
        // calculate the factor that is needed for transforming the value to pixels
        let factor = chart.factor
        
        let center = chart.centerOffsets
        
        for i in stride(from: 0, to: chart.data?.maxEntryCountSet?.entryCount ?? 0, by: 1)
        {
            
            let label = xAxis.valueFormatter?.stringForValue(Double(i), axis: xAxis) ?? ""
            
            let angle = (sliceangle * CGFloat(i) + chart.rotationAngle).truncatingRemainder(dividingBy: 360.0)
            
            let p = center.moving(distance: CGFloat(chart.yRange) * factor + xAxis.labelRotatedWidth / 2.0, atAngle: angle)
            
            let x = p.x
            var y = p.y
            
            drawLabel(context: context,
                      formattedLabel: label,
                      x: x,
                      y: y - xAxis.labelRotatedHeight / 2.0,
                      attributes: [NSAttributedString.Key.font: labelFont, NSAttributedString.Key.foregroundColor: labelTextColor],
                      anchor: drawLabelAnchor,
                      angleRadians: labelRotationAngleRadians)
            
            // drop lower
            y += 20
            let subLabel = xAxis.valueFormatter?.subStringForValue?(Double(i), axis: xAxis) ?? ""
            let subColor = xAxis.valueFormatter?.subStringColorForValue?(Double(i), axis: xAxis) ?? subLabelTextColor
            
            drawLabel(context: context,
                      formattedLabel: subLabel,
                      x: x,
                      y: y - xAxis.labelRotatedHeight / 2.0,
                      attributes: [NSAttributedString.Key.font: subLabelFont, NSAttributedString.Key.foregroundColor: subColor],
                      anchor: drawLabelAnchor,
                      angleRadians: labelRotationAngleRadians)
        }
    }
    
    @objc open func drawLabel(
        context: CGContext,
        formattedLabel: String,
        x: CGFloat,
        y: CGFloat,
        attributes: [NSAttributedString.Key : Any],
        anchor: CGPoint,
        angleRadians: CGFloat)
    {
        ChartUtils.drawText(
            context: context,
            text: formattedLabel,
            point: CGPoint(x: x, y: y),
            attributes: attributes,
            anchor: anchor,
            angleRadians: angleRadians)
    }
    
    open override func renderLimitLines(context: CGContext)
    {
        /// XAxis LimitLines on RadarChart not yet supported.
    }
}
