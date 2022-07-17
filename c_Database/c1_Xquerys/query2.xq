<results> {
for $dude in doc("input2.xml")//entry
 let $name := normalize-space(string-join($dude/title//text(), "")),
 $died := xs:integer($dude/@died)
 where $died lt 1600
 order by $died descending
 return <dude>{$name} (d. {$died})</dude>
}
</results>