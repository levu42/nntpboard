{include file=header.html.tpl title=$board.name}

<ul class="breadcrumb">{include file=board_breadcrumb.html.tpl board=$board}</ul>

{if !empty($board.desc)}<p class="well">{$board.desc}</p>{/if}

{if isset($board.childs)}
{assign var=restforen value=0}
{capture assign=childboards}
{foreach from=$board.childs item=child}
{if isset($child.childs)}
{include file=board_boards.html.tpl boardid=$child.boardid name=$child.name boards=$child.childs zeigekategorien=true}
{else}{assign var=restforen value=1}
{/if}
{/foreach}
{/capture}
{if $restforen == 1}{include file=board_boards.html.tpl name="Foren" boards=$board.childs}{/if}
{$childboards}
{/if}

<div class="btn-toolbar">
	<div class="btn-group">
		<a href="/unread.php?markread={$board.boardid}" class="btn">Forum als gelesen markieren</a>
	</div>




	{if isset($threads)}
	{if $pages > 1}
	<div class="pagination pagination-centered">
		<ul>
			{section name=page start=0 loop=$pages}
				{assign var=p value=$smarty.section.page.index}
				{if $p<=$page - 3 && $p>=6}
					<li {if $page==$p}class="active"{/if}><a href="viewboard.php?boardid={$board.boardid|escape:url}&amp;page={$p}">{$p+1}</a></li>
				{/if}
			{/section}
		</ul>
	</div>
	{/if}

	<div class="btn-group">
	{if ($mayPost)}<a class="btn btn-primary">Neuer Thread</a>{/if}
	</div>

</div>

<table class="table table-striped">
<thead>
<tr>
 <th class="title" colspan="2">Thema</th>
 <th class="postcount">Posts</th>
 <th class="poster">Geschrieben</th>
 <th class="lastpost">Letzte Antwort</th>
</tr>
</thead>
<tbody>
{foreach from=$threads item=thread name=counter}
 <tr class="boardentry thread {cycle values="even,odd"} {if $smarty.foreach.counter.first}first{/if}" onclick="document.location.href = document.getElementById('thread{$smarty.foreach.counter.iteration}').href;">
  <td class="icon"><img src="images/flagge{if $thread.unread}_unread{/if}.png" alt="Es sind {if $thread.unread}ungelesene{else}keine ungelesenen{/if} Posts vorhanden"/></td>
  <td class="title">
  <a class="subject" id="thread{$smarty.foreach.counter.iteration}" href="viewthread.php?boardid={$board.boardid|escape:url}&amp;threadid={$thread.threadid|encodeMessageID|escape:url}">{$thread.subject}</a>
  </td>
  <td class="postcount">
  <span class="posts">{$thread.posts}</span>
  </td>
  <td class="poster">
  <span class="info">von </span><span class="author">{include file=address.html.tpl address=$thread.author}</span>
  <br /><span class="info">am </span><span class="date">{$thread.date|date_format:"%d.%m.%Y %H:%M"}</span>
  </td>
  <td class="lastpost">
  <span class="info">von </span><span class="author">{include file=address.html.tpl address=$thread.lastpostauthor}</span>
  <br /><span class="info">am </span><a class="date" href="viewthread.php?boardid={$board.boardid|escape:url}&amp;messageid={$thread.lastpostmessageid|encodeMessageID|escape:url}">{$thread.lastpostdate|date_format:"%d.%m.%Y %H:%M"}</a>
  </td>
 </tr>
{foreachelse}
 <tr class="boardentry boardempty">
  <td colspan="5">Es wurden noch keine Threads verfasst.</td>
 </tr>
{/foreach}
</tbody>
</table>

<div class="page">
Seite {$page+1} von {$pages} &bull; 
{section name=page start=0 loop=$pages}
{assign var=p value=$smarty.section.page.index}
{if $page!=$p}<a href="viewboard.php?boardid={$board.boardid|escape:url}&amp;page={$p}" class="pagenumber">{else}<span class="selected-page">{/if}{$p+1}{if $page!=$p}</a>{else}</span>{/if}
{/section}
</div>
{/if}

{if ($mayPost)}
	<form action="post.php" method="get">
		<input type="hidden" name="boardid" value="{$board.boardid}" \>
		<input type="submit" class="btn btn-primary" name="" value="Neuer Thread" />
	</form>
{/if}

<form action="unread.php" method="get">
	<input type="hidden" name="markread" value="{$board.boardid}" \>
	<input type="submit" class="btn" name="" value="Forum als gelesen markieren" />
</form>

{include file=footer.html.tpl}
