// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductManagement {
    address payable internal contractOwner;

    constructor () {
        contractOwner = payable (msg.sender);
    }

    enum MarketPlaceStatus {
        Available,
        NotAvailable
    }

    enum ProductStatus {
        OrderPlaced,
        InProgress,
        Delivered,
        Returned
    }

    struct ProductStock {
        uint256 productStockId;
        address productOwner;
        string productName;
        string productDescription;
        uint256 productPrice;
        uint256 productStock;
        MarketPlaceStatus status;
    }

    struct Product {
        address productOwner;
        uint256 productId;
        string productName;
        string productDescription;
        uint256 productPrice;
        ProductStatus productStatus;
    }

    uint256 marketplaceProductId = 0;
    uint256 productId = 0;

    mapping(uint256 => ProductStock) private MarketplaceRecord;
    mapping(uint256 => Product) private ProductRecord;

    event ProductEvent(uint256 productId, string message);
    event Message(string message);

    modifier isowner {
        require(msg.sender == contractOwner, "You are not the admin");
        _;
    }

    function donate () public payable {}

    function withdraw () public payable isowner {
        (bool status, ) = contractOwner.call{value: address(this).balance}("");
        require(status, "Withdrawl failed");
    }

    function balance () public view isowner returns (uint256) {
        return address(this).balance;
    } 

    function listProduct(
        string calldata _productName,
        string calldata _productDescription,
        uint256 _productPrice,
        uint256 _productStock
    ) public {
        require(_productStock > 0, "Product out of stock");
        require(_productPrice > 0, "Enter a minimum amount to the product");

        MarketplaceRecord[marketplaceProductId] = ProductStock(
            marketplaceProductId,
            msg.sender,
            _productName,
            _productDescription,
            _productPrice,
            _productStock,
            MarketPlaceStatus.Available
        );
        emit ProductEvent(marketplaceProductId, "Product listed on marketplace");
        marketplaceProductId += 1;
    }

    function getProductStockDetails (uint256 _productId) public view returns (ProductStock memory) {
        return MarketplaceRecord[_productId];
    }

    function buyProduct (uint256 _productId) public payable {
        require(MarketplaceRecord[_productId].productStock > 0, "Stock unavailable");

        address payable productOwner = payable (MarketplaceRecord[_productId].productOwner);
        uint256 amount = MarketplaceRecord[_productId].productPrice * 1 ether;
        (bool status, ) = productOwner.call{value: amount}("");
        require(status, "Payment unsuccessfull");

        ProductRecord[productId] = Product (
            msg.sender,
            productId,
            MarketplaceRecord[_productId].productName,
            MarketplaceRecord[_productId].productDescription,
            MarketplaceRecord[_productId].productPrice,
            ProductStatus.OrderPlaced
        );
        MarketplaceRecord[_productId].productStock -= 1;

        if (MarketplaceRecord[_productId].productStock == 0) {
            MarketplaceRecord[_productId].status = MarketPlaceStatus.NotAvailable;
        }

        emit ProductEvent(productId, "Order placed successfully");
    }

    function sellProduct (uint256 _productId, address _newOwner) public {
        require (ProductRecord[_productId].productOwner == msg.sender, "You are not the owner");
        ProductRecord[_productId].productOwner = _newOwner;
        emit Message ("Ownership changed to new owner");
    }

    function isAvailable (uint256 _productId) public view returns (bool) {
        if (MarketplaceRecord[_productId].productStock > 0) {
            return true;
        }   else {
            return false;
        }
    } 

    function sellStock (uint256 _marketplaceId, address _newOwner) public {
        require(MarketplaceRecord[_marketplaceId].productOwner == msg.sender, "You are not the owner");
        MarketplaceRecord[_marketplaceId].productOwner = _newOwner;
        emit Message ("Marketplace ownership changed to new owner");
    }

    function isOwner (uint256 _productId) public view returns (bool) {
        if (ProductRecord[_productId].productOwner == msg.sender) {
            return true;
        }   else {
            return false;
        }
    }

    function updateStatus (uint256 _productId, ProductStatus _newStatus) public {
        require(ProductRecord[_productId].productOwner == msg.sender, "You are not the owner");
        ProductRecord[_productId].productStatus = _newStatus;
        emit Message ("Product status updated");
    }

    function getProductStatus (uint256 _productId) public view returns (Product memory) {
        return ProductRecord[_productId];
    }
}