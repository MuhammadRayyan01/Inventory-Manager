<?php
require_once __DIR__ . '/../db.php';

try {
    $stmt = $pdo->query('SELECT id, username, created_at FROM users LIMIT 20');
    $users = $stmt->fetchAll();
    echo "Users:\n";
    foreach ($users as $u) {
        echo sprintf("%d\t%s\t%s\n", $u['id'], $u['username'], $u['created_at']);
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage() . "\n";
}

?>
