(:~

    Transformation module generated from TEI ODD extensions for processing models.
    ODD: /db/apps/tei-publisher/odd/docbook.odd
 :)
xquery version "3.1";

module namespace model="http://www.tei-c.org/pm/models/docbook/fo";

declare default element namespace "http://docbook.org/ns/docbook";

declare namespace xhtml='http://www.w3.org/1999/xhtml';

declare namespace pb='http://teipublisher.com/1.0';

declare namespace xlink='http://www.w3.org/1999/xlink';

import module namespace css="http://www.tei-c.org/tei-simple/xquery/css";

import module namespace fo="http://www.tei-c.org/tei-simple/xquery/functions/fo";

(: Code listing :)
declare %private function model:code($config as map(*), $node as node()*, $class as xs:string+, $content) {
    $node ! (
        let $language := @language

        return

        <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format" space-before=".5em" space-after=".5em" padding-left="1em" padding-right="1em" padding-top=".5em" padding-bottom=".5em" border-color="#A0A0A0" border="solid 2pt" font-family="monospace" font-size=".85em" line-height="1.2" hyphenate="false" white-space="pre" wrap-option="wrap">{$config?apply-children($config, $node, $content)}</fo:block>
    )
};

(: Generated behaviour function for ident definitionList :)
declare %private function model:definitionList($config as map(*), $node as node()*, $class as xs:string+, $content) {
    $node ! (

        
        <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">{$config?apply-children($config, $node, $content)}</fo:block>
    )
};

(: Generated behaviour function for ident definition :)
declare %private function model:definition($config as map(*), $node as node()*, $class as xs:string+, $content, $term) {
    $node ! (

        
        <pb:template xmlns:pb="http://teipublisher.com/1.0">
                            <fo:block xmlns:fo="http://www.w3.org/1999/XSL/Format">{$config?apply-children($config, $node, $content)}</fo:block>
                        </pb:template>
    )
};

(: Generated behaviour function for ident iframe :)
declare %private function model:iframe($config as map(*), $node as node()*, $class as xs:string+, $content, $src, $width, $height) {
    $node ! (

        
        <t xmlns=""><iframe src="{$config?apply-children($config, $node, $src)}" width="{$config?apply-children($config, $node, $width)}" height="{$config?apply-children($config, $node, $height)}" frameborder="0" gesture="media" allow="encrypted-media" allowfullscreen="allowfullscreen"/></t>/*
    )
};

(: generated template function for element spec: article :)
declare %private function model:template-article3($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><html lang="{$config?apply-children($config, $node, $params?lang)}">{$config?apply-children($config, $node, $params?content)}</html></t>/*
};
(: generated template function for element spec: title :)
declare %private function model:template-title2($config as map(*), $node as node()*, $params as map(*)) {
    <t xmlns=""><h1>
                                <pb-link path="{$config?apply-children($config, $node, $params?path)}" emit="transcription">{$config?apply-children($config, $node, $params?content)}</pb-link>
                            </h1></t>/*
};
(:~

    Main entry point for the transformation.
    
 :)
declare function model:transform($options as map(*), $input as node()*) {
        
    let $config :=
        map:merge(($options,
            map {
                "output": ["fo","print"],
                "odd": "/db/apps/tei-publisher/odd/docbook.odd",
                "apply": model:apply#2,
                "apply-children": model:apply-children#3
            }
        ))
    let $config := fo:init($config, $input)
    
    return (
        
        let $output := model:apply($config, $input)
        return
            $output
    )
};

declare function model:apply($config as map(*), $input as node()*) {
        let $parameters := 
        if (exists($config?parameters)) then $config?parameters else map {}
        let $mode := 
        if (exists($config?mode)) then $config?mode else ()
        let $trackIds := 
        $parameters?track-ids
        let $get := 
        model:source($parameters, ?)
    return
    $input !         (
            let $node := 
                .
            return
                            typeswitch(.)
                    case element(article) return
                        if ($parameters?mode='summary') then
                            fo:block($config, ., ("tei-article2", css:map-rend-to-class(.)), info)
                        else
                            if (@xml:lang) then
                                (: No function found for behavior: pass-through :)
                                $config?apply($config, ./node())
                            else
                                fo:document($config, ., ("tei-article4", css:map-rend-to-class(.)), .)
                    case element(info) return
                        if (not(parent::article or parent::book)) then
                            fo:block($config, ., ("tei-info3", css:map-rend-to-class(.)), .)
                        else
                            if ($parameters?header='short') then
                                (
                                    fo:heading($config, ., ("tei-info5", css:map-rend-to-class(.)), title, 5),
                                    if (author) then
                                        fo:block($config, ., ("tei-info6", css:map-rend-to-class(.)), author)
                                    else
                                        ()
                                )

                            else
                                fo:block($config, ., ("tei-info7", css:map-rend-to-class(.)), (title, if ($parameters?skipAuthors) then () else author, pubdate, abstract))
                    case element(author) return
                        if (preceding-sibling::author and not($parameters?skipAuthors)) then
                            fo:inline($config, ., ("tei-author3", css:map-rend-to-class(.)), (', ', personname, affiliation))
                        else
                            if (not($parameters?skipAuthors)) then
                                fo:inline($config, ., ("tei-author4", css:map-rend-to-class(.)), (personname, affiliation))
                            else
                                $config?apply($config, ./node())
                    case element(personname) return
                        fo:inline($config, ., ("tei-personname", css:map-rend-to-class(.)), (firstname, ' ', surname))
                    case element(affiliation) return
                        fo:inline($config, ., ("tei-affiliation", css:map-rend-to-class(.)), (', ', .))
                    case element(title) return
                        if ($parameters?mode='summary') then
                            let $params := 
                                map {
                                    "content": node(),
                                    "path": $parameters?path
                                }

                                                        let $content := 
                                model:template-title2($config, ., $params)
                            return
                                                        fo:block(map:merge(($config, map:entry("template", true()))), ., ("tei-title2", "articletitle", css:map-rend-to-class(.)), $content)
                        else
                            if ($parameters?mode='breadcrumbs') then
                                fo:inline($config, ., ("tei-title3", css:map-rend-to-class(.)), .)
                            else
                                if (parent::note) then
                                    fo:heading($config, ., ("tei-title4", css:map-rend-to-class(.)), ., 4)
                                else
                                    if (parent::info and $parameters?header='short') then
                                        fo:link($config, ., ("tei-title5", css:map-rend-to-class(.)), ., $parameters?doc, map {})
                                    else
                                        if (parent::info) then
                                            fo:heading($config, ., ("tei-title6", "doc-title", css:map-rend-to-class(.)), ., ())
                                        else
                                            fo:heading($config, ., ("tei-title7", "title", css:map-rend-to-class(.)), ., if ($parameters?view='single') then count(ancestor::section) + 1 else count($get(.)/ancestor::section))
                    case element(section) return
                        if ($parameters?mode='breadcrumbs') then
                            (
                                fo:inline($config, ., ("tei-section1", css:map-rend-to-class(.)), $get(.)/ancestor::section/title),
                                fo:inline($config, ., ("tei-section2", css:map-rend-to-class(.)), title)
                            )

                        else
                            fo:block($config, ., ("tei-section4", css:map-rend-to-class(.)), .)
                    case element(para) return
                        fo:paragraph($config, ., ("tei-para", css:map-rend-to-class(.)), .)
                    case element(emphasis) return
                        if (@role='bold') then
                            fo:inline($config, ., ("tei-emphasis1", css:map-rend-to-class(.)), .)
                        else
                            fo:inline($config, ., ("tei-emphasis2", css:map-rend-to-class(.)), .)
                    case element(code) return
                        fo:inline($config, ., ("tei-code2", "code", css:map-rend-to-class(.)), .)
                    case element(figure) return
                        if (title|info/title) then
                            fo:figure($config, ., ("tei-figure2", "figure", css:map-rend-to-class(.)), *[not(self::title|self::info)], title/node()|info/title/node())
                        else
                            fo:figure($config, ., ("tei-figure3", css:map-rend-to-class(.)), ., ())
                    case element(informalfigure) return
                        if (caption) then
                            fo:figure($config, ., ("tei-informalfigure1", "figure", css:map-rend-to-class(.)), *[not(self::caption)], caption/node())
                        else
                            fo:figure($config, ., ("tei-informalfigure2", "figure", css:map-rend-to-class(.)), ., ())
                    case element(imagedata) return
                        fo:graphic($config, ., ("tei-imagedata2", css:map-rend-to-class(.)), ., @fileref, @width, (), (), ())
                    case element(itemizedlist) return
                        fo:list($config, ., ("tei-itemizedlist", css:map-rend-to-class(.)), listitem, ())
                    case element(listitem) return
                        fo:listItem($config, ., ("tei-listitem", css:map-rend-to-class(.)), ., ())
                    case element(orderedlist) return
                        fo:list($config, ., ("tei-orderedlist", css:map-rend-to-class(.)), listitem, 'ordered')
                    case element(procedure) return
                        fo:list($config, ., ("tei-procedure", css:map-rend-to-class(.)), step, 'ordered')
                    case element(step) return
                        fo:listItem($config, ., ("tei-step", css:map-rend-to-class(.)), ., ())
                    case element(variablelist) return
                        model:definitionList($config, ., ("tei-variablelist", css:map-rend-to-class(.)), varlistentry)
                    case element(varlistentry) return
                        model:definition($config, ., ("tei-varlistentry", css:map-rend-to-class(.)), listitem/node(), term/node())
                    case element(table) return
                        if (title) then
                            (
                                fo:heading($config, ., ("tei-table1", css:map-rend-to-class(.)), title, ()),
                                fo:table($config, ., ("tei-table2", css:map-rend-to-class(.)), .//tr)
                            )

                        else
                            fo:table($config, ., ("tei-table3", "table", css:map-rend-to-class(.)), .//tr)
                    case element(informaltable) return
                        fo:table($config, ., ("tei-informaltable", "table", css:map-rend-to-class(.)), .//tr)
                    case element(tr) return
                        fo:row($config, ., ("tei-tr", css:map-rend-to-class(.)), .)
                    case element(td) return
                        if (parent::tr/parent::thead) then
                            fo:cell($config, ., ("tei-td1", css:map-rend-to-class(.)), ., ())
                        else
                            fo:cell($config, ., ("tei-td2", css:map-rend-to-class(.)), ., ())
                    case element(programlisting) return
                        fo:block($config, ., ("tei-programlisting6", "programlisting", css:map-rend-to-class(.)), .)
                    case element(synopsis) return
                        fo:block($config, ., ("tei-synopsis3", "programlisting", css:map-rend-to-class(.)), .)
                    case element(example) return
                        fo:figure($config, ., ("tei-example", css:map-rend-to-class(.)), *[not(self::title|self::info)], info/title/node()|title/node())
                    case element(function) return
                        fo:inline($config, ., ("tei-function", "code", css:map-rend-to-class(.)), .)
                    case element(command) return
                        fo:inline($config, ., ("tei-command", "code", css:map-rend-to-class(.)), .)
                    case element(parameter) return
                        fo:inline($config, ., ("tei-parameter", "code", css:map-rend-to-class(.)), .)
                    case element(filename) return
                        fo:inline($config, ., ("tei-filename", "code", css:map-rend-to-class(.)), .)
                    case element(note) return
                        fo:block($config, ., ("tei-note4", css:map-rend-to-class(.)), .)
                    case element(tag) return
                        fo:inline($config, ., ("tei-tag", "code", css:map-rend-to-class(.)), .)
                    case element(link) return
                        if (@linkend) then
                            fo:link($config, ., ("tei-link3", css:map-rend-to-class(.)), ., concat('?odd=', request:get-parameter('odd', ()), '&amp;view=',                             request:get-parameter('view', ()), '&amp;id=', @linkend), map {})
                        else
                            if (@xlink:show='new') then
                                fo:link($config, ., ("tei-link4", css:map-rend-to-class(.)), ., @xlink:href, map {"target": '_new'})
                            else
                                fo:link($config, ., ("tei-link5", css:map-rend-to-class(.)), ., @xlink:href, map {})
                    case element(guibutton) return
                        fo:inline($config, ., ("tei-guibutton", "guibutton", css:map-rend-to-class(.)), .)
                    case element(guilabel) return
                        fo:inline($config, ., ("tei-guilabel", css:map-rend-to-class(.)), .)
                    case element(videodata) return
                        model:iframe($config, ., ("tei-videodata2", css:map-rend-to-class(.)), ., @fileref, @width, @depth)
                    case element(abstract) return
                        if ($parameters?path = $parameters?active) then
                            fo:omit($config, ., ("tei-abstract1", css:map-rend-to-class(.)), .)
                        else
                            fo:block($config, ., ("tei-abstract2", css:map-rend-to-class(.)), .)
                    case element(pubdate) return
                        fo:inline($config, ., ("tei-pubdate", "pubdate", css:map-rend-to-class(.)), format-date(., '[MNn] [D1], [Y0001]', 'en_US', (), ()))
                    case element(footnote) return
                        fo:note($config, ., ("tei-footnote", css:map-rend-to-class(.)), ., (), ())
                    case element() return
                        fo:inline($config, ., ("tei--element", css:map-rend-to-class(.)), .)
                    case text() | xs:anyAtomicType return
                        fo:escapeChars(.)
                    default return 
                        $config?apply($config, ./node())

        )

};

declare function model:apply-children($config as map(*), $node as element(), $content as item()*) {
        
    if ($config?template) then
        $content
    else
        $content ! (
            typeswitch(.)
                case element() return
                    if (. is $node) then
                        $config?apply($config, ./node())
                    else
                        $config?apply($config, .)
                default return
                    fo:escapeChars(.)
        )
};

declare function model:source($parameters as map(*), $elem as element()) {
        
    let $id := $elem/@exist:id
    return
        if ($id and $parameters?root) then
            util:node-by-id($parameters?root, $id)
        else
            $elem
};

declare function model:process-annotation($html, $context as node()) {
        
    let $classRegex := analyze-string($html/@class, '\s?annotation-([^\s]+)\s?')
    return
        if ($classRegex//fn:match) then (
            if ($html/@data-type) then
                ()
            else
                attribute data-type { ($classRegex//fn:group)[1]/string() },
            if ($html/@data-annotation) then
                ()
            else
                attribute data-annotation {
                    map:merge($context/@* ! map:entry(node-name(.), ./string()))
                    => serialize(map { "method": "json" })
                }
        ) else
            ()
                    
};

declare function model:map($html, $context as node(), $trackIds as item()?) {
        
    if ($trackIds) then
        for $node in $html
        return
            typeswitch ($node)
                case document-node() | comment() | processing-instruction() return 
                    $node
                case element() return
                    if ($node/@class = ("footnote")) then
                        if (local-name($node) = 'pb-popover') then
                            ()
                        else
                            element { node-name($node) }{
                                $node/@*,
                                $node/*[@class="fn-number"],
                                model:map($node/*[@class="fn-content"], $context, $trackIds)
                            }
                    else
                        element { node-name($node) }{
                            attribute data-tei { util:node-id($context) },
                            $node/@*,
                            model:process-annotation($node, $context),
                            $node/node()
                        }
                default return
                    <pb-anchor data-tei="{ util:node-id($context) }">{$node}</pb-anchor>
    else
        $html
                    
};

