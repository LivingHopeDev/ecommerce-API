/*
  Warnings:

  - Added the required column `quantity` to the `cartItems` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX `addresses_userId_fkey` ON `addresses`;

-- DropIndex
DROP INDEX `cartItems_productId_fkey` ON `cartitems`;

-- DropIndex
DROP INDEX `cartItems_userId_fkey` ON `cartitems`;

-- AlterTable
ALTER TABLE `cartitems` ADD COLUMN `quantity` INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE `addresses` ADD CONSTRAINT `addresses_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cartItems` ADD CONSTRAINT `cartItems_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `cartItems` ADD CONSTRAINT `cartItems_productId_fkey` FOREIGN KEY (`productId`) REFERENCES `products`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
