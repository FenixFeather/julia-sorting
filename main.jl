#/bin/env julia

using Debug
using Winston

include("functions.jl")

type sortData
    curveColor::String
    curveLabel::String
    curveY::Array
end

function test(range, f)
    times = Array(Float64, length(range))
    current = 1
    for i in range
        bla = rand(Int, i)
        ## start = time()
        tic()
        f(bla)
        times[current] = toc()
        current += 1
    end

    return times
end

function plotStuff(x, ydata...)
    result = FramedPlot(title="Sorting comparison", xlabel="Number of Elements", ylabel="Time (s)")
    curves = Array(Curve, length(ydata))
    for i in 1:length(curves)
        curves[i] = Curve(x, ydata[i].curveY, color=ydata[i].curveColor, label=ydata[i].curveLabel)
        setattr(curves[i], "label", ydata[i].curveLabel)
    end
    
    legend = Legend(.1,.9, {curves...})
    
    add(result, legend, curves...)

    return result
end

function main()

    range = 1000:1000:100000
    ## range = 1:52
    
    x = [range]
    
    ymerge = test(range, mergesort)
    yinsert = test(range, insertionsort)

    mergeCurve = sortData("red", "mergesort", ymerge)
    insertCurve = sortData("blue", "insertionSort", yinsert)
    
    myPlot = plotStuff(x, mergeCurve, insertCurve)
    display(myPlot)
    savefig(myPlot, "mergesort-insertionsort.png")
end

main()
