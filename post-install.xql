xquery version "3.0";

import module namespace pmu="http://www.tei-c.org/tei-simple/xquery/util";
import module namespace odd="http://www.tei-c.org/tei-simple/odd2odd";
import module namespace nav="http://www.tei-c.org/tei-simple/navigation" at "modules/navigation.xql";
import module namespace config="http://www.tei-c.org/tei-simple/config" at "modules/config.xqm";
import module namespace tpu="http://www.tei-c.org/tei-publisher/util" at "modules/lib/util.xql";

(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

declare function local:generate-code($collection as xs:string) {
    for $source in $config:odd-available
    let $odd := doc($collection || "/odd/" || $source)
    let $pi := tpu:parse-pi($odd, (), $source)
    for $module in
        if ($pi?output) then
            tokenize($pi?output)
        else
            ("web", "print", "latex", "epub", "fo")
    for $file in pmu:process-odd (
        (:    $odd as document-node():)
        odd:get-compiled($collection || "/odd" , $source),
        (:    $output-root as xs:string    :)
        $collection || "/transform",
        (:    $mode as xs:string    :)
        $module,
        (:    $relPath as xs:string    :)
        "transform",
        (:    $config as element(modules)?    :)
        doc($collection || "/odd/configuration.xml")/*,
        $module = "web")
    return
        ()
};

if (not(sm:user-exists("tei-demo"))) then
    sm:create-account("tei-demo", "demo", "tei", ())
else
    (),
(: API needs dba rights for LaTeX :)
sm:chgrp(xs:anyURI($target || "/modules/lib/api-dba.xql"), "dba"),
sm:chmod(xs:anyURI($target || "/modules/lib/api-dba.xql"), "rwxr-Sr-x"),

xmldb:create-collection($target || "/data", "playground"),
sm:chmod(xs:anyURI($target || "/data/playground"), "rwxrwxr-x"),
sm:chown(xs:anyURI($target || "/data/playground"), "tei-demo"),
sm:chgrp(xs:anyURI($target || "/data/playground"), "tei"),
xmldb:create-collection($target || "/data", "dts"),
sm:chmod(xs:anyURI($target || "/data/dts"), "rwxrwxr-x"),
sm:chown(xs:anyURI($target || "/data/dts"), "tei-demo"),
sm:chgrp(xs:anyURI($target || "/data/dts"), "tei"),
sm:chmod(xs:anyURI($target || "/data/annotate"), "rwxrwxr-x"),
sm:chown(xs:anyURI($target || "/data/annotate"), "tei-demo"),
sm:chown(xs:anyURI($target || "/data/registers"), "tei-demo"),
for $resource in xmldb:get-child-resources($target || "/data/registers")
return (
    sm:chown(xs:anyURI($target || "/data/registers/" || $resource), "tei-demo"),
    sm:chmod(xs:anyURI($target || "/data/registers/" || $resource), "rw-rw-r--")
),
sm:chmod(xs:anyURI($target || "/data/jats"), "rwxrwxr-x"),
sm:chown(xs:anyURI($target || "/data/jats"), "tei-demo"),
sm:chmod(xs:anyURI($target || "/data/teilex0"), "rwxrwxr-x"),
sm:chown(xs:anyURI($target || "/data/teilex0"), "tei-demo"),
xmldb:create-collection($target || "/data", "temp"),
sm:chmod(xs:anyURI($target || "/data/temp"), "rwxrwxr-x"),
sm:chown(xs:anyURI($target || "/data/temp"), "tei"),
sm:chgrp(xs:anyURI($target || "/data/temp"), "tei"),
sm:chmod(xs:anyURI($target || "/odd"), "rwxrwxr-x"),
sm:chmod(xs:anyURI($target || "/transform"), "rwxrwxr-x"),
for $resource in xmldb:get-child-resources($target || "/transform")
return
    if (ends-with($resource, "-main.xql")) then
        sm:chmod(xs:anyURI($target || "/transform/" || $resource), "rwxrwxr-x")
    else
        sm:chmod(xs:anyURI($target || "/transform/" || $resource), "rw-rw-r--")