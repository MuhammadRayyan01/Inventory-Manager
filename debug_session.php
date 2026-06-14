<?php
// debug_session.php - simple helper to inspect current session state
session_start();
header('Content-Type: text/html; charset=utf-8');
echo '<h3>Current PHP Session</h3>';
echo '<pre>';
var_dump($_SESSION);
echo '</pre>';
echo '<h3>Cookies</h3>';
echo '<pre>';
var_dump($_COOKIE);
echo '</pre>';
echo '<p>Access this page before and after login to confirm `$_SESSION["user_id"]` is being set.</p>';
?>
