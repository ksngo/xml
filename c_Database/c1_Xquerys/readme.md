## 1 VERSION DECLARATION

xquery version “1.0”;  
xquery encoding “utf-8”;

## 2 QUERY PROLOG

### 2a namespace declarations
declare namespace myns = "http://www.myns.org/ns/";

default namespaces  
xml = http://www.w3.org/XML/1998/namespace  
xs = http://www.w3.org/2001/XMLSchema  
xsi = http://www.w3.org/2001/XMLSchema-instance  
fn = http://www.w3.org/2005/xpath-functions  
local = http://www.w3.org/2005/xquery-local-functions

### 2b import schemas (dont understand)

import schema fobo=”http://www.fromoldbooks.org/Search/”;  
import schema “http://www.exmple.org/” at “http://www.example.org/xsdfiles/”;  
import schema fobo=”http://www.fromoldbooks.org/Search/”  
 at “http://www.fromoldbooks.org/Search/xml/search.xsd”,  
 “http://www.fromoldbooks.org/Search/xml/additional.xsd”;  

### 2c import modules

import module namespace fobo=”http://www.example.org/ns/” at “fobo-search.xqm”;  
import module “global-defs.xqm”;

### 2d variable declarations

declare variable $socks := “black”;  
declare variable $sockprice as xs:decimal := 3.6;  
declare variable $argyle as element(# ) := ```<sock>argyle</sock>```  
declare variable $places as xs:string := doc(“places.xml”);  
declare variable $items-per-page as xs:integer := 16;  
declare variable $config as element(config, mytype:config) := ```<config>36</config>```;  

### 2e functions

declare variable $james := ```<person><name>James</name><socks>argyle</socks></person>;```  
declare function local:get-sock-color(
 $person as element(person)) as xs:string
{
 xs:string($person/socks)
};
local:get-sock-color($james)

### 2f external functions

declare function java:imagesize($imgfile as xs:anyURI) as xs:integer#  external;

## 3 QUERY BODY

### 3a FLWOR (Xquery 3)

(for | let | window3.0 | where | group by3.0 | order by | count3.0)

#### 3a.1 for
for $entry as element(entry) at $n in //entry  
return ```<li>{$n}. {$entry/@id}</li>```

for $a in (1, 2, 3),$b in (4, 5)  
return $a + $b

#### 3a.2 let
let $x as xs:decimal := math:sin(0.5)  
return $x  

for $a in (1, 2, 3)  
let $b := $a *  $a  
return ```<r>{$b}</r>```

#### 3a.3 where
for $person in /dictionary/entry[@born lt 1750] 

same as => 

for $person in /dictionary/entry  
where # born lt 1750

for $a in (1 to 50), $b in (2, 3, 5, 7)  
where $a mod $b eq 0
return $a #  $b

#### 3a.4 order by
for $person in //entry[@born]  
order by xs:integer(@born) ascending  
return $person/title


#### 3a.5 count

for $boy at $boypos in (“Simon”, “Nigel”, “David”),  
 $game at $gamepos in (“pushups”, “situps”)  
 count $count  
return  
 ```<tuple n=”{$count”}>```  
 boy {$boypos} is {$boy}, item {$gamepos}: {$game}  
 ```</tuple>```

without count =>

for $activity at $n in (  
 for $boy at $boypos in (“Simon”, “Nigel”, “David”),  
 $game at $gamepos in (“pushups”, “situps”)  
 return  
 concat("boy ", $boypos, " is ", $boy,  
 " item ", $gamepos, ": ", $game)  
 )  
return ```<tuple n=”{$n}”>{$activity}</tuple>```

output=>

```<tuple n=”1”>boy 1 is Simon, item 1: pushups</tuple>```  
```<tuple n=”2”>boy 1 is Simon, item 2: situps</tuple>```  
```<tuple n=”3”>boy 2 is Nigel, item 1: pushups</tuple>```  
```<tuple n=”4”>boy 2 is Nigel, item 2: situps</tuple>```  
```<tuple n=”5”>boy 3 is David, item 1: pushups</tuple>```  
```<tuple n=”6”>boy 3 is David, item 2: situps</tuple>```  

### 3b typeswith expressions

typeswitch ($entry)  
 case $e as element(entry, blindEntry) return ()  
 case $e as element(entry, entry) return process-entry($e)  
 default return fn:error(xs:QName(“my:err042”), “bad entry type”)  

### 3c element constructors
#### 3c.1 direct
  let $isaac := ```<entry id=”newton-isaac” born=”1642” died=”1737”>```  
  ```<title>Sir Isaac Newton</title>```  
  ```</entry>```  
  return $isaac/title

  let $box:= ```<rect xmlns=”http://www.w3.org/2000/svg”
  width=”{$width}” height=”{$width #  2}”
  x=”{$isaac/@born}” y=”{math:sin(xs:integer($isaac/@died))}” />```,  
  $text := ```<text>His name was {$isaac/title/text()}.</text>```

  let $c := <--#  this is an example of a direct XML comment constructor # -->,  
      $p := ```<?php echo date() ?>```  


#### 3c.2 computed

declare namespace svg = “http://www.w3.org/2000/svg”;  
let $width := 30,  
 $height := 20,  
 $isaac := ```<entry id=”newton-isaac” born=”1622” died=”1736”>```  
 ```<title>Sir Isaac Newton</title>```
 ```</entry>```,  
$box := element svg:box {  
 attribute width { $width },  
 attribute height { $height },  
 attribute x { $isaac/@born },  
 attribute y { math:sin(xs:integer($isaac/@died)) }  
},  
 $p := element text {  
 fn:concat(  
 “His name was “,  
 data($isaac/title),  
 “.”)  
 } return ($box, $p)  

  generates following output:  
 ```<svg:box xmlns:svg=”http://www.w3.org/2000/svg” width=”30” height=”20” x=”1622” y=”0.96375518644307”/>```  
```<text>His name was Sir Isaac Newton.</text>```
