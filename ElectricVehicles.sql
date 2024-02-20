-- In this project, we will explore 4 IEA (International Energy Agency) datasets to evaluate the demand and popularity of electric vehicles using SSMS (SQL Server Management Studio).
-- The 4 datasets contain data about:
-- 1) Electric cars.
-- 2) Electric vans.
-- 3) Electric buses.
-- 4) Electric trucks.

-- For starters, let's see how sales of electric vehicles(EV_ sales) have formed over the years on a worldwide scale.

Select ec.region, ec.[year], SUM(Distinct ec.[value]) AS Cars,
SUM(Distinct ev.[value]) AS Vans,
SUM(Distinct eb.[value]) AS Buses,
Round(SUM(Distinct et.[value]), 0) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ev.region = 'World'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]

--Worldwide cars seem to have the higher numbers. How about the EU?

Select ec.region, ec.[year], SUM(Distinct(ec.[value])) AS Cars,
SUM(Distinct(ev.[value])) AS Vans,
SUM(Distinct(eb.[value])) AS Buses,
SUM(Distinct(et.[value])) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ec.region = 'EU27'
and eb.region = 'EU27'
and et.region = 'EU27'
and ev.region = 'EU27'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]
Order By [year]

-- The situation is similar in the EU. Cars seem to have the higher numbers in sales.

---------------------------------------------------------------------------------------------------------------------------

-- We can see that the demand for electric vehicles is continuously growing over the years. Let's check how these row numbers translate into percentage (%) growth. The 'Percentage_Growth' shows the growth
-- that an 'x' year had compared to the previous.

-- For world.


With EV_Sales_Percentage_Growth_World (region, [year], Cars, Vans, Buses, Trucks)
AS
(
Select ec.region, ec.[year], SUM(Distinct ec.[value]) AS Cars,
SUM(Distinct ev.[value]) AS Vans,
SUM(Distinct eb.[value]) AS Buses,
Round(SUM(Distinct et.[value]), 0) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ev.region = 'World'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]
)
Select region, [year], Round((Cars - LAG(Cars) OVER(Order By [year])) / CAST(LAG(Cars) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Cars_Percentage_Growth,
Round((Vans - LAG(Vans) OVER(Order By [year])) / CAST(LAG(Vans) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Vans_Percentage_Growth,
Round((Buses - LAG(Buses) OVER(Order By [year])) / CAST(LAG(Buses) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Buses_Percentage_Growth,
Round((Trucks - LAG(Trucks) OVER(Order By [year])) / CAST(LAG(Trucks) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Trucks_Percentage_Growth
From EV_Sales_Percentage_Growth_World

-- And for EU.

With EV_Sales_Percentage_Growth_EU (region, [year], Cars, Vans, Buses, Trucks)
AS
(
Select ec.region, ec.[year], SUM(Distinct(ec.[value])) AS Cars,
SUM(Distinct(ev.[value])) AS Vans,
SUM(Distinct(eb.[value])) AS Buses,
SUM(Distinct(et.[value])) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ec.region = 'EU27'
and eb.region = 'EU27'
and et.region = 'EU27'
and ev.region = 'EU27'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]
)
Select region, [year], Round((Cars - LAG(Cars) OVER(Order By [year])) / CAST(LAG(Cars) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Cars_Percentage_Growth,
Round((Vans - LAG(Vans) OVER(Order By [year])) / CAST(LAG(Vans) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Vans_Percentage_Growth,
Round((Buses - LAG(Buses) OVER(Order By [year])) / CAST(LAG(Buses) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Buses_Percentage_Growth,
Round((Trucks - LAG(Trucks) OVER(Order By [year])) / CAST(LAG(Trucks) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Trucks_Percentage_Growth
From EV_Sales_Percentage_Growth_EU

-- In the next query we will explore what is the oil displacement in million lge over the years from all type of vehicles.

-- LGE
-- The abbreviation “lge” stands for “liters of gasoline equivalent.” It is commonly used to express the energy content or consumption of alternative fuels or electric vehicles in terms comparable to traditional 
-- gasoline. For example, when discussing the energy capacity of an electric vehicle battery, we might refer to it as having a certain number of liters of gasoline equivalent (lge) to provide a meaningful 
-- comparison with internal combustion engine vehicles.

-- Keep in mind that the calculations are for million lge.
-- So if for example there is an LGE value of 100 it means 100.000.000 “liters of gasoline equivalent”.

Select ec.region, ec.[year], ec.parameter, SUM(Distinct(ec.[value])) AS LGE_Cars,
Round(SUM(Distinct(ev.[value])), 1) AS LGE_Vans,
SUM(Distinct(eb.[value])) AS LGE_Buses,
Round(SUM(Distinct(et.[value])), 1) AS LGE_Trucks,
Round(SUM(Distinct(ec.[value])) + SUM(Distinct(eb.[value])) + SUM(Distinct(et.[value])) + SUM(Distinct(ev.[value])), 1) AS LGE_Total
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
and ec.parameter = eb.parameter
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
and ec.parameter = et.parameter
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
and ec.parameter = ev.parameter
Where ec.parameter = 'Oil displacement, million lge'
and ec.parameter = 'Oil displacement, million lge'
and et.parameter = 'Oil displacement, million lge'
and ev.parameter = 'Oil displacement, million lge'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and ev.region = 'World'
Group By ec.region, ec.[year], ec.parameter, eb.region, eb.[year], eb.parameter, et.region, et.[year], et.parameter, ev.region, ev.[year], ev.parameter

-- And in percentage terms.
-- As before, the percentage growth shows us the rise of an 'x' year compared to the previous, but for oil displacement in lge this time.

Drop Table If Exists #LGE_Percentage_Growth
Create Table #LGE_Percentage_Growth
(
region nvarchar(255),
[year] float,
parameter nvarchar(255),
LGE_Cars float,
LGE_Vans float,
LGE_Buses float,
LGE_Trucks float,
LGE_Total float
)

Insert Into #LGE_Percentage_Growth
Select ec.region, ec.[year], ec.parameter, SUM(Distinct(ec.[value])) AS LGE_Cars,
Round(SUM(Distinct(ev.[value])), 1) AS LGE_Vans,
SUM(Distinct(eb.[value])) AS LGE_Buses,
Round(SUM(Distinct(et.[value])), 1) AS LGE_Trucks,
Round(SUM(Distinct(ec.[value])) + SUM(Distinct(eb.[value])) + SUM(Distinct(et.[value])) + SUM(Distinct(ev.[value])), 1) AS LGE_Total
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
and ec.parameter = eb.parameter
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
and ec.parameter = et.parameter
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
and ec.parameter = ev.parameter
Where ec.parameter = 'Oil displacement, million lge'
and ec.parameter = 'Oil displacement, million lge'
and et.parameter = 'Oil displacement, million lge'
and ev.parameter = 'Oil displacement, million lge'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and ev.region = 'World'
Group By ec.region, ec.[year], ec.parameter, eb.region, eb.[year], eb.parameter, et.region, et.[year], et.parameter, ev.region, ev.[year], ev.parameter

Select region, [year], parameter, Round((LGE_Cars - LAG(LGE_Cars) OVER(Order By [year])) / CAST(LAG(LGE_Cars) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Cars_LGE_Percentage_Growth,
Round((LGE_Vans - LAG(LGE_Vans) OVER(Order By [year])) / CAST(LAG(LGE_Vans) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Vans_LGE_Percentage_Growth,
Round((LGE_Buses - LAG(LGE_Buses) OVER(Order By [year])) / CAST(LAG(LGE_Buses) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Buses_LGE_Percentage_Growth,
Round((LGE_Trucks - LAG(LGE_Trucks) OVER(Order By [year])) / CAST(LAG(LGE_Trucks) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Trucks_LGE_Percentage_Growth,
Round((LGE_Total - LAG(LGE_Total) OVER(Order By [year])) / CAST(LAG(LGE_Total) OVER(Order By [year]) AS FLOAT) * 100, 1) AS LGE_Total_Percentage_Growth
From #LGE_Percentage_Growth

-- Let's now take a closer look at sales for each type individually. We will also separate the BEV(Battery Electric Vehicles) & PHEV(Plug-in Hybrid Electric Vehicles) data.
-- For cars, worldwide.

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Cars
Where region = 'World'
and parameter = 'EV sales'
Order By [year], powertrain

-- For cars, in EU.

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Cars
Where region = 'EU27'
and parameter = 'EV sales'
Order By [year], powertrain

-- Vans / Worldwide

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Vans
Where region = 'World'
and parameter = 'EV sales'
Order By [year], powertrain

--Vans / EU

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Vans
Where region = 'EU27'
and parameter = 'EV sales'
Order By [year], powertrain

--Buses / Worldwide

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Buses
Where region = 'World'
and parameter = 'EV sales'
Order By [year], powertrain

-- Buses / EU

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Buses
Where region = 'EU27'
and parameter = 'EV sales'
Order by [year], powertrain

-- Trucks / Worldwide

Select region, parameter, mode, [year], powertrain, Round([value], 0) AS [value]
From ElectricVehicles..EV_Trucks
Where region = 'World'
and parameter = 'EV sales'
Order By [year], powertrain

-- Trucks / EU

Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Trucks
Where region = 'EU27'
and parameter = 'EV sales'
Order By [year], powertrain

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- The rest of the project is about creating views. These views are going to be useful for later visualizations with Tableau (see 'Electric Vehicles - Tableau Project').

-- Creating View for: EV sales worldwide.

Create View EV_Sales_World AS
Select ec.region, ec.[year], SUM(Distinct ec.[value]) AS Cars,
SUM(Distinct ev.[value]) AS Vans,
SUM(Distinct eb.[value]) AS Buses,
Round(SUM(Distinct et.[value]), 0) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ev.region = 'World'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]

-- Creating View for: EV sales in the EU.

Create View EV_Sales_EU AS
Select ec.region, ec.[year], SUM(Distinct ec.[value]) AS Cars,
SUM(Distinct ev.[value]) AS Vans,
SUM(Distinct eb.[value]) AS Buses,
SUM(Distinct et.[value]) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ec.region = 'EU27'
and eb.region = 'EU27'
and et.region = 'EU27'
and ev.region = 'EU27'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]

--Creating View for: EV sales percentage growth worldwide.

Create View EV_Sales_Percentage_Growth_World AS
With EV_Sales_Percentage_Growth_World (region, [year], Cars, Vans, Buses, Trucks)
AS
(
Select ec.region, ec.[year], SUM(Distinct ec.[value]) AS Cars,
SUM(Distinct ev.[value]) AS Vans,
SUM(Distinct eb.[value]) AS Buses,
Round(SUM(Distinct et.[value]), 0) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ev.region = 'World'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]
)
Select region, [year], Round((Cars - LAG(Cars) OVER(Order By [year])) / CAST(LAG(Cars) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Cars_Percentage_Growth,
Round((Vans - LAG(Vans) OVER(Order By [year])) / CAST(LAG(Vans) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Vans_Percentage_Growth,
Round((Buses - LAG(Buses) OVER(Order By [year])) / CAST(LAG(Buses) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Buses_Percentage_Growth,
Round((Trucks - LAG(Trucks) OVER(Order By [year])) / CAST(LAG(Trucks) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Trucks_Percentage_Growth
From EV_Sales_Percentage_Growth_World

-- Creating view for: EV sales percentage growth in the EU.

Create View EV_Sales_Percentage_Growth_EU AS
With EV_Sales_Percentage_Growth_EU (region, [year], Cars, Vans, Buses, Trucks)
AS
(
Select ec.region, ec.[year], SUM(Distinct(ec.[value])) AS Cars,
SUM(Distinct(ev.[value])) AS Vans,
SUM(Distinct(eb.[value])) AS Buses,
SUM(Distinct(et.[value])) AS Trucks
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
Where ec.parameter = 'EV sales'
and eb.parameter = 'EV sales'
and et.parameter = 'EV sales'
and ev.parameter = 'EV sales'
and ec.region = 'EU27'
and eb.region = 'EU27'
and et.region = 'EU27'
and ev.region = 'EU27'
Group By ec.region, ec.[year], eb.region, eb.[year], et.region, et.[year], ev.region, ev.[year]
)
Select region, [year], Round((Cars - LAG(Cars) OVER(Order By [year])) / CAST(LAG(Cars) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Cars_Percentage_Growth,
Round((Vans - LAG(Vans) OVER(Order By [year])) / CAST(LAG(Vans) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Vans_Percentage_Growth,
Round((Buses - LAG(Buses) OVER(Order By [year])) / CAST(LAG(Buses) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Buses_Percentage_Growth,
Round((Trucks - LAG(Trucks) OVER(Order By [year])) / CAST(LAG(Trucks) OVER(Order By [year]) AS FLOAT) * 100, 2) AS Trucks_Percentage_Growth
From EV_Sales_Percentage_Growth_EU

-- Creating View for: LGE.

Create View LGE AS
Select ec.region, ec.[year], ec.parameter, SUM(Distinct(ec.[value])) AS LGE_Cars,
Round(SUM(Distinct(ev.[value])), 1) AS LGE_Vans,
SUM(Distinct(eb.[value])) AS LGE_Buses,
Round(SUM(Distinct(et.[value])), 1) AS LGE_Trucks,
Round(SUM(Distinct(ec.[value])) + SUM(Distinct(eb.[value])) + SUM(Distinct(et.[value])) + SUM(Distinct(ev.[value])), 1) AS LGE_Total
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
and ec.parameter = eb.parameter
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
and ec.parameter = et.parameter
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
and ec.parameter = ev.parameter
Where ec.parameter = 'Oil displacement, million lge'
and ec.parameter = 'Oil displacement, million lge'
and et.parameter = 'Oil displacement, million lge'
and ev.parameter = 'Oil displacement, million lge'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and ev.region = 'World'
Group By ec.region, ec.[year], ec.parameter, eb.region, eb.[year], eb.parameter, et.region, et.[year], et.parameter, ev.region, ev.[year], ev.parameter

-- Creating View for: LGE percentage growth.

Create View LGE_Percentage_Growth AS
With LGE_Percentage_Growth (region, [year], parameter, LGE_Cars, LGE_Vans, LGE_Buses, LGE_Trucks, LGE_Total)
AS
(
Select ec.region, ec.[year], ec.parameter, SUM(Distinct(ec.[value])) AS LGE_Cars,
Round(SUM(Distinct(ev.[value])), 1) AS LGE_Vans,
SUM(Distinct(eb.[value])) AS LGE_Buses,
Round(SUM(Distinct(et.[value])), 1) AS LGE_Trucks,
Round(SUM(Distinct(ec.[value])) + SUM(Distinct(eb.[value])) + SUM(Distinct(et.[value])) + SUM(Distinct(ev.[value])), 1) AS LGE_Total
From ElectricVehicles..EV_Cars ec
Full Outer Join ElectricVehicles..EV_Buses eb
On ec.region = eb.region
and ec.[year] = eb.[year]
and ec.parameter = eb.parameter
Full Outer Join ElectricVehicles..EV_Trucks et
On ec.region = et.region
and ec.[year] = et.[year]
and ec.parameter = et.parameter
Full Outer Join ElectricVehicles..EV_Vans ev
On ec.region = ev.region
and ec.[year] = ev.[year]
and ec.parameter = ev.parameter
Where ec.parameter = 'Oil displacement, million lge'
and ec.parameter = 'Oil displacement, million lge'
and et.parameter = 'Oil displacement, million lge'
and ev.parameter = 'Oil displacement, million lge'
and ec.region = 'World'
and eb.region = 'World'
and et.region = 'World'
and ev.region = 'World'
Group By ec.region, ec.[year], ec.parameter, eb.region, eb.[year], eb.parameter, et.region, et.[year], et.parameter, ev.region, ev.[year], ev.parameter
)
Select region, [year], parameter, Round((LGE_Cars - LAG(LGE_Cars) OVER(Order By [year])) / CAST(LAG(LGE_Cars) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Cars_LGE_Percentage_Growth,
Round((LGE_Vans - LAG(LGE_Vans) OVER(Order By [year])) / CAST(LAG(LGE_Vans) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Vans_LGE_Percentage_Growth,
Round((LGE_Buses - LAG(LGE_Buses) OVER(Order By [year])) / CAST(LAG(LGE_Buses) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Buses_LGE_Percentage_Growth,
Round((LGE_Trucks - LAG(LGE_Trucks) OVER(Order By [year])) / CAST(LAG(LGE_Trucks) OVER(Order By [year]) AS FLOAT) * 100, 1) AS Trucks_LGE_Percentage_Growth,
Round((LGE_Total - LAG(LGE_Total) OVER(Order By [year])) / CAST(LAG(LGE_Total) OVER(Order By [year]) AS FLOAT) * 100, 1) AS LGE_Total_Percentage_Growth
From LGE_Percentage_Growth

-- Creating View for: Cars sales worldwide.

Create View Cars_Sales_World AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Cars
Where region = 'World'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Cars_Sales_World
Order By [year], powertrain

-- Creating View for: Cars sales in the EU.

Create View Cars_Sales_EU AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Cars
Where region = 'EU27'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Cars_Sales_EU
Order By [year], powertrain

-- Creating View for: Vans sales worldwide.

Create View Vans_Sales_World AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Vans
Where region = 'World'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Vans_Sales_World
Order By [year], powertrain

-- Creating View for: Vans sales in the EU.

Create View Vans_Sales_EU AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Vans
Where region = 'EU27'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Vans_Sales_EU
Order By [year], powertrain

-- Creating View for: Buses sales worldwide.

Create View Buses_Sales_World AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Buses
Where region = 'World'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Buses_Sales_World
Order By [year], powertrain

-- Creating View for: Buses sales in the EU.

Create View Buses_Sales_EU AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Buses
Where region = 'EU27'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Buses_Sales_EU
Order By [year], powertrain

-- Creating View for: Trucks sales worldwide.

Create View Trucks_Sales_World AS
Select region, parameter, mode, [year], powertrain, Round([value], 0) AS [value]
From ElectricVehicles..EV_Trucks
Where region = 'World'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Trucks_Sales_World
Order By [year], powertrain

-- Creating View for: Trucks sales in the EU.

Create View Trucks_Sales_EU AS
Select region, parameter, mode, [year], powertrain, [value]
From ElectricVehicles..EV_Trucks
Where region = 'EU27'
and parameter = 'EV sales'
--Order By [year], powertrain

Select *
From Trucks_Sales_EU
Order By [year], powertrain