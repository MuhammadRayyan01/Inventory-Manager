<?php
// setup.php
// Run this once to create the database, tables and sample data from schema.sql

ini_set('display_errors', 1);
error_reporting(E_ALL);

$host = 'localhost';
$username = 'root';
$password = '';
$schemaFile = __DIR__ . '/schema.sql';

if (!file_exists($schemaFile)) {
    die("schema.sql not found in project root. Please ensure schema.sql is present.\n");
}

// Connect to MySQL server (no database selected yet)
$conn = @new mysqli($host, $username, $password);
if ($conn->connect_error) {
    // Try again using TCP connector instead of socket by using 127.0.0.1
    $host2 = '127.0.0.1';
    $conn = @new mysqli($host2, $username, $password);
    if ($conn->connect_error) {
        die('Connection failed: ' . $conn->connect_error . "\n" .
            "Tried hosts: $host and $host2.\nPlease ensure MySQL is running and accessible, and update credentials in this script if needed.");
    }
}

$sql = file_get_contents($schemaFile);
if ($sql === false) {
    die('Failed to read schema.sql');
}

// Execute multi-statement SQL
if ($conn->multi_query($sql)) {
    do {
        if ($res = $conn->store_result()) {
            $res->free();
        }
    } while ($conn->more_results() && $conn->next_result());

    echo "Schema executed successfully.\n";
} else {
    echo "Error executing schema: " . $conn->error . "\n";
}

$conn->close();

echo "\nNext steps:\n";
echo "- Start Apache and MySQL in XAMPP.\n";
echo "- Open the app: http://localhost/Inventory-Manager/login.php\n";
echo "- Default sample user: username 'admin' password 'admin123' (from schema.sql).\n";

?>
