<?php

class Thread {
	private $threadid;
	private $charset;
	private $subject;
	private $date;
	private $author;
	private $messages = array();
	
	private $group;
	
	public function __construct($message) {
		$this->threadid = $message->getMessageID();
		$this->subject = $message->getSubject();
		$this->date = $message->getDate();
		$this->author = $message->getAuthor();
		$this->group = $message->getGroup();
		$this->charset = $message->getCharset();
	}
	
	public function getMessageIDs() {
		return array_keys($this->messages);
	}

	public function getMessageCount() {
		return count($this->messages);
	}
	
	public function addMessage($message) {
		if (!in_array($message->getMessageID(), $this->getMessageIDs())) {
			$this->messages[$message->getMessageID()] = array("date" => $message->getDate(), "author" => $message->getAuthor());
			$this->sort();
		}
	}

	private function sort() {
		if (!function_exists("cmpMessageArray")) {
			function cmpMessageArray($a, $b) {
				return $a["date"] - $b["date"];
			}
		}
		uasort($this->messages, cmpMessageArray);
	}

	public function removeMessage($message) {
		unset($this->messages[$message->getMessageID()]);
		$this->sort();
	}
	
	public function getThreadID() {
		return $this->threadid;
	}
	
	public function getSubject($charset = null) {
		if ($charset !== null) {
			return iconv($this->getCharset(), $charset, $this->getSubject());
		}
		return $this->subject;
	}
	
	public function getDate() {
		return $this->date;
	}
	
	public function getAuthor() {
		return $this->author;
	}
	
	public function getPosts() {
		return count($this->messages);
	}
	
	public function getLastPostMessageID() {
		return array_shift(array_slice(array_keys($this->messages),-1));
	}
	
	public function getLastPostDate() {
		return $this->messages[$this->getLastPostMessageID()]["date"];
	}
	
	public function getLastPostAuthor() {
		return $this->messages[$this->getLastPostMessageID()]["author"];
	}
	
	public function getCharset() {
		return $this->charset;
	}
	
	public function getGroup() {
		return $this->group;
	}
}

?>
