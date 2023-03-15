import module namespace m='http://www.tei-c.org/pm/models/vangogh/fo' at '/db/apps/tei-publisher/transform/vangogh-fo.xql';

declare variable $xml external;

declare variable $parameters external;

let $options := map {
    "styles": ["transform/vangogh.css"],
    "collection": "/db/apps/tei-publisher/transform",
    "parameters": if (exists($parameters)) then $parameters else map {}
}
return m:transform($options, $xml)