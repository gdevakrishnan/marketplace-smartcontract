# Marketplace - ProductManagement Smart Contract

## Overview

The `ProductManagement` smart contract is a decentralized marketplace where users can list, buy, sell, and manage products. It allows users to track product ownership, update product statuses, and manage stock availability. The contract is implemented in Solidity for deployment on the Ethereum blockchain.

## Features

- **Product Listing**: Users can list products with descriptions, prices, and stock quantities.
- **Product Purchase**: Buyers can purchase products, transferring ownership.
- **Product Status Tracking**: Products have different statuses such as `OrderPlaced`, `InProgress`, `Delivered`, and `Returned`.
- **Ownership Transfer**: Products and product stock can be transferred to new owners.
- **Marketplace Management**: Marketplace products have an availability status.
- **Admin Controls**: The contract owner can withdraw funds.

## Contract Details

### State Variables

- `contractOwner`: The owner of the contract with admin privileges.
- `marketplaceProductId`: Tracks the total number of products listed.
- `productId`: Tracks the total number of individual products sold.
- `MarketplaceRecord`: A mapping storing marketplace products.
- `ProductRecord`: A mapping storing individual purchased products.

### Enums

- **`MarketPlaceStatus`**
  - `Available`
  - `NotAvailable`

- **`ProductStatus`**
  - `OrderPlaced`
  - `InProgress`
  - `Delivered`
  - `Returned`

### Structs

- **`ProductStock`**: Stores marketplace product details.
- **`Product`**: Stores details of purchased products.

### Events

- `ProductEvent(uint256 productId, string message)`: Emitted when a product event occurs.
- `Message(string message)`: Emitted when an ownership change or update happens.

## Functions

### Admin Functions

- `donate()`: Allows users to donate funds to the contract.
- `withdraw()`: Allows the contract owner to withdraw the contract balance.
- `balance()`: Returns the contract's current balance.

### Marketplace Functions

- `listProduct(string calldata _productName, string calldata _productDescription, uint256 _productPrice, uint256 _productStock)`: Lists a new product for sale.
- `getProductStockDetails(uint256 _productId)`: Retrieves product details from the marketplace.
- `isAvailable(uint256 _productId)`: Checks if a product is available for purchase.

### Purchase & Ownership Functions

- `buyProduct(uint256 _productId)`: Allows users to purchase a product.
- `sellProduct(uint256 _productId, address _newOwner)`: Transfers ownership of a purchased product.
- `sellStock(uint256 _marketplaceId, address _newOwner)`: Transfers ownership of a marketplace product stock.
- `isOwner(uint256 _productId)`: Checks if the sender owns a product.

### Product Status Management

- `updateStatus(uint256 _productId, ProductStatus _newStatus)`: Updates the status of a purchased product.
- `getProductStatus(uint256 _productId)`: Retrieves the current status of a purchased product.

## Requirements & Restrictions

- Only the contract owner can withdraw funds.
- Products must have a price greater than zero.
- Stock must be available for purchase.
- Only product owners can update statuses or transfer ownership.

## License

This contract is licensed under the **MIT License**.
