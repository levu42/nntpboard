{include file=header.html.tpl}
<h1>{$board.name|escape:html}</h1>

<ul class="breadcrumb navigation">{include file=board_breadcrumb.html.tpl board=$board}</ul>

<p class="desc">{$board.desc}</p>

{if isset($board.childs)}<div class="subboards">{include file=board_boards.html.tpl subboards=$board.childs}</div>{/if}

<div class="options">
 {if ($mayPost)}<a href="post.php?boardid={$board.boardid}" class="newthread">Neuer Thread</a>{/if}
</div>

{section name=page start=0 loop=$pages}
{assign var=p value=$smarty.section.page.index}
 {if $page!=$p}<a href="viewboard.php?boardid={$board.boardid}&amp;page={$p}">{/if}{$p+1}{if $page!=$p}</a>{/if}
{/section}

{if isset($threads)}
<ul class="threads">
{foreach from=$threads item=thread}
 <li class="thread {cycle values="odd,even"}{if $thread.unread} unread{/if}">
  <a class="subject" href="viewthread.php?boardid={$board.boardid|escape:url}&amp;threadid={$thread.threadid|escape:url}">{$thread.subject}</a>
  <span class="posts">{$thread.posts}</span>
  <span class="thread">
   <span class="date">{$thread.date|date_format:"%d.%m.%Y %H:%M"}</span>
   von <span class="author">{$thread.author}</span>
  </span>
  <span class="lastpost">
   <a class="date" href="viewthread.php?boardid={$board.boardid}&amp;messageid={$thread.lastpostmessageid}">{$thread.lastpostdate|date_format:"%d.%m.%Y %H:%M"}</a>
   von <span class="author">{$thread.lastpostauthor}</span>
  </span>
 </li>
{/foreach}
</ul>
{/if}
{include file=footer.html.tpl}
