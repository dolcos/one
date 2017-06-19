/**
 * Created by juan9 on 6/18/2017.
 */

    //No usado, esta en d3v4, y tengo d3v3.
 var margin = {top: 20, right: 20, bottom: 100, left: 80},
        width = 960 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom;


    var x = d3.scaleBand().range([0,width]).padding(0.1);

    var y = d3.scaleLinear().range([height,0]);


    var svg = d3.select("body").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    d3.json(url, function (error, data) {
        data.forEach(function (d) {
            d.Cantidad = +d.Cantidad;
        });

        x.domain(data.map(function(d) { return d.Provincia}));
        y.domain([0, d3.max(data, function(d) { return d.Cantidad; })]);

        svg.append("g")
            .attr("class", "x axis")
            .attr("transform", "translate(0," + height + ")")
            .call(d3.axisBottom(x))
            .selectAll("text")
            .style("text-anchor", "end")
            .attr("dx", "-.8em")
            .attr("dy", "-.55em")
            .attr("transform", "rotate(-90)" );

        svg.append("g")
            .attr("class", "y axis")
            .call(d3.axisLeft(y));

        svg.append("text")
            .attr("transform", "rotate(-90)")
            .attr("y", 0 - margin.left)
            .attr("x", 0 - (height/2))
            .attr("dy", ".71em")
            .style("text-anchor", "middle")
            .text("Cantidad");

        svg.selectAll("bar")
        .data(data)
        .enter().append("rect")
        .style("fill", "steelblue")
        .attr("x", function(d) { return x(d.Provincia); })
        .attr("width", x.bandwidth())
        .attr("y", function(d) { return y(d.Cantidad); })
        .attr("height", function(d) { return height - y(d.Cantidad); });

    });