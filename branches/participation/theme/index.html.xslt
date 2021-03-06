<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:atom="http://www.w3.org/2005/Atom"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:planet="http://planet.intertwingly.net/"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="atom planet xhtml">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:template match="atom:feed">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html xmlns="http://www.w3.org/1999/xhtml">

      <!-- head -->
      <head>
        <title><xsl:value-of select='atom:title'/></title>
        <meta charset='utf-8'/>
        <meta name='generator' content='{atom:generator}'/>
        <link href='planet.css' rel='stylesheet' type='text/css'/>
        <link href='img/mozilla-16.png' rel='shortcut icon' type='image/png'/>
        <xsl:if test='atom:link[@rel="self"]/@type'>
          <link rel='alternate' href='{atom:link[@rel="self"]/@href}'
            title='{atom:title/text()}' type='{atom:link[@rel="self"]/@type}'/>
        </xsl:if>
        <script defer="defer" type="text/javascript" src="personalize.js">
          <xsl:comment><!--HTML Compatibility--></xsl:comment>
        </script>
        <script defer="defer" type="text/javascript" src="query.js">
          <xsl:comment><!--HTML Compatibility--></xsl:comment>
        </script>
      </head>

      <body>

        <div id='utility'>
          <p><strong>Looking For</strong></p>
          <ul>
            <li><a href='http://www.mozilla.org/'>mozilla.org</a></li>
            <li><a href='https://wiki.mozilla.org/'>Wiki</a></li>
            <li><a href='https://developer.mozilla.org/'>Developer Center</a></li>
            <li><a href='http://www.firefox.com/'>Firefox</a></li>
            <li><a href='http://www.getthunderbird.com/'>Thunderbird</a></li>
          </ul>
        </div>

        <div id='header'>
          <div id='dino'>
            <h1>
              <a href='/' title='Back to home page'><xsl:value-of select='atom:title'/></a>
            </h1>
          </div>
        </div>

        <div class='main-content'>

          <xsl:for-each select='atom:entry'>
            <!-- date header -->
            <xsl:variable name="date" select="substring(atom:updated,1,10)"/>
            <xsl:if test="not(preceding-sibling::atom:entry
              [substring(atom:updated,1,10) = $date])">
              <h2>
                <time datetime="{$date}">
                  <xsl:value-of select="substring-before(atom:updated/@planet:format,', ')"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="substring-before(substring-after(atom:updated/@planet:format,', '), ' ')"/>
                </time>
              </h2>
            </xsl:if>

            <div class="news {atom:source/planet:css-id}">

              <xsl:if test="@xml:lang">
                <xsl:attribute name="xml:lang">
                  <xsl:value-of select="@xml:lang"/>
                </xsl:attribute>
              </xsl:if>

              <!-- entry title -->
              <h3>
                <xsl:if test="atom:source/atom:icon">
                  <img src="{atom:source/atom:icon}" class="icon"/>
                </xsl:if>
               <a>
                  <xsl:if test="atom:source/atom:link[@rel='alternate']/@href">
                    <xsl:attribute name="href">
                      <xsl:value-of
                        select="atom:source/atom:link[@rel='alternate']/@href"/>
                    </xsl:attribute>
                  </xsl:if>

                  <xsl:attribute name="title">
                    <xsl:value-of select="atom:source/atom:title"/>
                  </xsl:attribute>
                  <xsl:value-of select="atom:source/planet:name"/>
                </a>
                <xsl:if test="string-length(atom:title) &gt; 0">
                  <xsl:text> &#x2014; </xsl:text>
                  <a href="{atom:link[@rel='alternate']/@href}">
                    <xsl:if test="atom:title/@xml:lang != @xml:lang">
                      <xsl:attribute name="xml:lang" select="{atom:title/@xml:lang}"/>
                    </xsl:if>
                    <xsl:value-of select="atom:title"/>
                  </a>
                </xsl:if>
              </h3>

              <!-- entry content -->
              <div class='entry'>
                <xsl:choose>
                  <xsl:when test="atom:content">
                    <xsl:apply-templates select="atom:content"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:apply-templates select="atom:summary"/>
                  </xsl:otherwise>
                </xsl:choose>
              </div>

              <!-- entry footer -->
              <div class="permalink">
                <xsl:if test="atom:link[@rel='license'] or
                              atom:source/atom:link[@rel='license'] or
                              atom:rights or atom:source/atom:rights">
                  <a>
                    <xsl:if test="atom:source/atom:link[@rel='license']/@href">
                      <xsl:attribute name="rel">license</xsl:attribute>
                      <xsl:attribute name="href">
                        <xsl:value-of select="atom:source/atom:link[@rel='license']/@href"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="atom:link[@rel='license']/@href">
                      <xsl:attribute name="rel">license</xsl:attribute>
                      <xsl:attribute name="href">
                        <xsl:value-of select="atom:link[@rel='license']/@href"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="atom:source/atom:rights">
                      <xsl:attribute name="title">
                        <xsl:value-of select="atom:source/atom:rights"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="atom:rights">
                      <xsl:attribute name="title">
                        <xsl:value-of select="atom:rights"/>
                      </xsl:attribute>
                    </xsl:if>
                    <xsl:text>&#169;</xsl:text>
                  </a>
                  <xsl:text> </xsl:text>
                </xsl:if>
                <a href="{atom:link[@rel='alternate']/@href}">
                  <xsl:choose>
                    <xsl:when test="atom:author/atom:name">
                      <xsl:if test="not(atom:link[@rel='license'] or
                                        atom:source/atom:link[@rel='license'] or
                                        atom:rights or atom:source/atom:rights)">
                        <xsl:text>by </xsl:text>
                      </xsl:if>
                      <xsl:value-of select="atom:author/atom:name"/>
                      <xsl:text> at </xsl:text>
                    </xsl:when>
                    <xsl:when test="atom:source/atom:author/atom:name">
                      <xsl:if test="not(atom:link[@rel='license'] or
                                        atom:source/atom:link[@rel='license'] or
                                        atom:rights or atom:source/atom:rights)">
                        <xsl:text>by </xsl:text>
                      </xsl:if>
                      <xsl:value-of select="atom:source/atom:author/atom:name"/>
                      <xsl:text> at </xsl:text>
                    </xsl:when>
                  </xsl:choose>
                  <time datetime="{atom:updated}" title="GMT">
                    <xsl:value-of select="atom:updated/@planet:format"/>
                  </time>
                </a>
              </div>
            </div>
          </xsl:for-each>

        </div>

        <div class='sidebar'>
          <div class='disclaimer'>
            <h2><xsl:value-of select='atom:title'/></h2>
            <p>Collected here are the most recent blog posts from all over the Mozilla community.
               The content here is unfiltered and uncensored, and represents the views of individual community members.
               Individual posts are owned by their authors -- see original source for licensing information.</p>
          </div>
          <div class='feeds'>
            <h2>Subscribe to Planet</h2>
              <p>Feeds:</p>
              <ul>
                <li><a href='atom.xml'>Atom</a></li>
                <li><a href='rss20.xml'>RSS 2.0</a></li>
                <li><a href='rss10.xml'>RSS 1.0</a></li>
              </ul>
              <p/>
              <p>Subscription list:</p>
              <ul>
                <li class='foaf'><a href='foafroll.xml'>FOAF</a></li>
                <li class='opml'><a href='opml.xml'>OPML</a></li>
              </ul>

              <p>Last update: <time datetime="{atom:updated}" title="GMT">
                 <xsl:value-of select='atom:updated/@planet:format'/></time></p>
          </div>

          <div class='main'>
            <h2>Other Planets</h2>
            <ul class='planets'>
              <li><a href='http://planet.mozilla.org/projects/'>Projects</a></li>
              <li><a href='http://planet.mozilla.org/thunderbird/'>Planet Thunderbird</a></li>
              <li><a href='http://planet.bugzilla.org/'>Planet Bugzilla</a></li>
              <li><a href='https://quality.mozilla.org/'>Planet QMO</a></li>
              <li><a href='http://planet.mozilla.org/ateam/'>Planet Automation</a></li>
              <li><a href='http://planet.mozilla.org/interns/'>Mozilla Interns</a></li>
              <li><a href='http://planet.mozilla.org/research/'>Mozilla Research</a></li>
              <li><a href='http://mozilla.com.cn/topic/3/'>Mozilla Online (Chinese)</a></li>
            </ul>

            <div id='sidebar'/>

            <h2>Subscriptions</h2>
            <ul class='subscriptions'>
              <xsl:for-each select="planet:source">
                <xsl:sort select="planet:name"/>
                <xsl:variable name="id" select="atom:id"/>
                <xsl:variable name="posts"
                  select="/atom:feed/atom:entry[atom:source/atom:id = $id]"/>
                <li>
                  <!-- icon -->
                  <a title="subscribe">
                    <xsl:choose>
                      <xsl:when test="planet:http_location">
                        <xsl:attribute name="href">
                          <xsl:value-of select="planet:http_location"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:when test="atom:link[@rel='self']/@href">
                        <xsl:attribute name="href">
                          <xsl:value-of select="atom:link[@rel='self']/@href"/>
                        </xsl:attribute>
                      </xsl:when>
                    </xsl:choose>
                    <img src="img/feed-icon-10x10.png" alt="(feed)"/>
                  </a>
                  <xsl:text> </xsl:text>

                  <!-- name -->
                  <a>
                    <xsl:if test="atom:link[@rel='alternate']/@href">
                      <xsl:attribute name="href">
                        <xsl:value-of select="atom:link[@rel='alternate']/@href"/>
                      </xsl:attribute>
                    </xsl:if>

                    <xsl:choose>
                      <xsl:when test="planet:message">
                        <xsl:attribute name="class">
                          <xsl:if test="$posts">active message</xsl:if>
                          <xsl:if test="not($posts)">message</xsl:if>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:value-of select="planet:message"/>
                        </xsl:attribute>
                      </xsl:when>
                      <xsl:when test="atom:title">
                        <xsl:attribute name="title">
                          <xsl:value-of select="atom:title"/>
                       </xsl:attribute>
                        <xsl:if test="$posts">
                          <xsl:attribute name="class">active</xsl:attribute>
                        </xsl:if>
                      </xsl:when>
                    </xsl:choose>
                    <xsl:value-of select="planet:name"/>
                  </a>

                  <xsl:if test="$posts[string-length(atom:title) &gt; 0]">
                    <ul>
                      <xsl:for-each select="$posts">
                        <xsl:if test="string-length(atom:title) &gt; 0">
                          <li>
                            <a href="{atom:link[@rel='alternate']/@href}">
                              <xsl:if test="atom:title/@xml:lang != @xml:lang">
                                <xsl:attribute name="xml:lang"
                                  select="{atom:title/@xml:lang}"/>
                              </xsl:if>
                              <xsl:value-of select="atom:title"/>
                            </a>
                          </li>
                        </xsl:if>
                      </xsl:for-each>
                    </ul>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
            <div class='bottom'/>
          </div>
        </div>

        <div id='footer'>
          <div id='footer-content'>
            <p>Maintained by the <a href='https://bugzilla.mozilla.org/enter_bug.cgi?product=Websites&amp;component=planet.mozilla.org'>Planet Mozilla Module Team</a>. Powered by <a href='http://www.intertwingly.net/code/venus/'>Planet Venus</a>. View our <a href='http://www.mozilla.org/about/policies/privacy-policy.html'>Privacy Policy</a>.</p>
          </div>
        </div>

      </body>

    </html>
  </xsl:template>

  <!-- xhtml content -->
  <xsl:template match='atom:content/xhtml:div | atom:summary/xhtml:div'>
    <xsl:copy>
      <xsl:if test='../@xml:lang and not(../@xml:lang = ../../@xml:lang)'>
        <xsl:attribute name='xml:lang'>
          <xsl:value-of select='../@xml:lang'/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name='class'>content</xsl:attribute>
      <xsl:apply-templates select='@*|node()'/>
    </xsl:copy>
  </xsl:template>

  <!-- plain text content -->
  <xsl:template match='atom:content/text() | atom:summary/text()'>
    <div class='content' xmlns='http://www.w3.org/1999/xhtml'>
      <xsl:if test='../@xml:lang and not(../@xml:lang = ../../@xml:lang)'>
        <xsl:attribute name='xml:lang'>
          <xsl:value-of select='../@xml:lang'/>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select='.'/>
    </div>
  </xsl:template>

  <!-- Remove stray atom elements -->
  <xsl:template match='atom:*'>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Feedburner detritus -->
  <xsl:template match="xhtml:div[@class='feedflare']"/>

  <!-- Strip site meter -->
  <xsl:template match="xhtml:div[comment()[. = ' Site Meter ']]"/>

  <!-- pass through everything else -->
  <xsl:template match='@*|node()'>
    <xsl:copy>
      <xsl:apply-templates select='@*|node()'/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
