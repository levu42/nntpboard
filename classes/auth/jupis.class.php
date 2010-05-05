<?php

// http://pear.php.net/package/Net_LDAP2
require_once("Net/LDAP2.php");

require_once(dirname(__FILE__)."/../auth.class.php");
require_once(dirname(__FILE__)."/../exceptions/auth.exception.php");

class JuPisAnonAuth extends AbstractAuth implements Auth {
	private $readdate = null;
	private $readthreads = array();

	public function __construct() {
		// Alle Posts vor dem Login sind schon gelesen ;)
		$this->readdate = time();
	}

	public function getAddress() {
		return null;
	}

	public function isUnreadThread($thread) {
		// Falls die Nachricht aelter als readdate ist, gilt sie als gelesen
		if ($thread->getLastPostDate() < $this->readdate) {
			return false;
		}
		// Entweder wir kennen den Thread noch gar nicht ...
		if (!isset($this->readthreads[$thread->getThreadID()])) {
			return true;
		}
		// ... oder der Timestamp hat sich veraendert
		if ($this->readthreads[$thread->getThreadID()] < $thread->getLastPostDate()) {
			return true;
		}
		return false;
	}

	public function markReadThread($thread) {
		// Trage den aktuellen Timestamp ein
		$this->readthreads[$thread->getThreadID()] = $thread->getLastPostDate();
	}

	public function getNNTPUsername() {
		return null;
	}

	public function getNNTPPassword() {
		return null;
	}
}

class JuPisAuth extends JuPisAnonAuth {
	public static function authenticate($user, $pass) {
		$auth = new JuPisAuth($user, $pass);
		// fetchUserDetails() wirft eine AuthException, wenn es Probleme gab
		$auth->fetchUserDetails();
		return $auth;
	}
	
	public static function getAnonymousAuth() {
		return new JuPisAnonAuth();
	}

	private $username;
	private $password;

	public function __construct($username, $password) {
		parent::__construct();
		$this->username = $username;
		$this->password = $password;
	}

	public function getAddress() {
		return new Address($this->username, $this->username . "@community.junge-piraten.de");
	}

	public function getNNTPUsername() {
		return $this->username;
	}

	public function getNNTPPassword() {
		return $this->password;
	}

	/* ****** */

	public function fetchUserDetails() {
		$link = $this->getLDAPLink();
		// TODO mailadresse oder so holen
		// TODO gelesene posts laden
		$link->done();
	}

	private function getUserDN() {
		return "uid=" . $this->username . ",ou=accounts,ou=community,o=Junge Piraten,c=DE";
	}

	private function getLDAPLink() {
		$link = Net_LDAP2::connect(array("binddn" => $this->getUserDN(), "bindpw" => $this->password, "port" => 10389) );
		if ($link instanceof PEAR_Error) {
			throw new LoginFailedAuthException($this->username);
		}
		return $link;
	}
}

?>
