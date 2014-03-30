<?php
require 'Kint/Kint.class.php';
require_once '../app/Mage.php';
Mage::app();

umask(0);
Mage::app('admin');
 
$session = Mage::getSingleton('adminhtml/session');

$products = Mage::getResourceModel('catalog/product_collection')
->addAttributeToSelect('*')
->addAttributeToFilter('status', 1);




function orphaned($products) {
/**
*
* Check all products to ensure they are all listed
*
*/

  $notListed = array();
	foreach($products as $product) {

	$available = $product->getCategoryIds();
	
		if(count($available) == 0) {
			$notListed[] = $product;
	}	
    }

return $notListed;

}






if($_GET["action"] == "orphaned") {
$result = orphaned($products);
    echo "<h2>The following products are active but not in any category</h2>";
    echo "<table width=100%>";
    
    foreach($result as $product) {
	echo '<tr><td>' . $product->getName() . '</td>';
	echo '</tr>';
    }
    echo '</table>';
}



?>
