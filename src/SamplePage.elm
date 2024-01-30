module SamplePage exposing (rawSamplePage)


rawSamplePage : String
rawSamplePage =
    """
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="refresh" content="1200">
<title>Dom6 - WhoNeedsJ</title>

<style type="text/css">
table.basictab
{ width: 400px;
background-color: #fafafa;
border: 1px #888888 solid;
border-collapse: collapse;
border-spacing: 0px; }

td.redbolddata
{ border-bottom: 1px #888888 solid;
background-color: #880000;
border: 1px #888888 solid;
font-family: Verdana;
font-weight: bold;
font-size: 11px;
padding-left: 8px;
color: #ffffff; }

td.blackbolddata
{ border-bottom: 1px #888888 solid;
background-color: #333333;
border: 1px #888888 solid;
font-family: Verdana;
font-weight: bold;
font-size: 11px;
padding-left: 8px;
color: #ffffff; }

td.blackdata
{ border-bottom: 1px #888888 solid;
text-align: left;
font-family: Verdana, sans-serif, Arial;
font-weight: normal;
font-size: .7em;
color: #ffffff;
background-color: #333333;
padding-top: 4px;
padding-bottom: 4px;
padding-left: 8px;
padding-right: 0px; }

td.greydata
{ border-bottom: 1px #888888 solid;
text-align: left;
font-family: Verdana, sans-serif, Arial;
font-weight: normal;
font-size: .7em;
color: #404040;
background-color: #aaaaaa;
padding-top: 4px;
padding-bottom: 4px;
padding-left: 8px;
padding-right: 0px; }

td.lightgreydata
{ border-bottom: 1px #888888 solid;
border-left: 1px #888888 solid;
text-align: left;
font-family: Verdana, sans-serif, Arial;
font-weight: normal;
font-size: .7em;
color: #404040;
background-color: #dadada;
padding-top: 4px;
padding-bottom: 4px;
padding-left: 8px;
padding-right: 0px; }

td.whitedata
{ border-bottom: 1px #888888 solid;
border-left: 1px #888888 solid;
text-align: left;
font-family: Verdana, sans-serif, Arial;
font-weight: normal;
font-size: .7em;
color: #404040;
background-color: #fafafa;
padding-top: 4px;
padding-bottom: 4px;
padding-left: 8px;
padding-right: 0px; }
</style>

</head>
<body>

<table class="basictab" cellspacing="0">
<tr>
<td class="blackbolddata" colspan="2">WhoNeedsJ, turn 31</td>
</tr>
<tr>
<td class="whitedata">Arcoscephale, Golden Era</td>
<td class="whitedata">-</td>
</tr>
<tr>
<td class="lightgreydata">Tir na n'Og, Land of the Ever Young</td>
<td class="lightgreydata">-</td>
</tr>
<tr>
<td class="whitedata">Ur, The First City</td>
<td class="whitedata">-</td>
</tr>
<tr>
<td class="lightgreydata">Kailasa, Rise of the Ape Kings</td>
<td class="lightgreydata">Turn played</td>
</tr>
</table>

</body>
</html>
"""
