"use strict";
/// <reference path="../csgo.d.ts" />
/// <reference path="../common/formattext.ts" />
var ShoppingCart;
(function (ShoppingCart) {
    class GlobalCart {
        static instance;
        MAX_PER_ITEM = 10;
        MAX_CART = 100;
        items = [];
        totalItems = 0;
        totalPrice = 0;
        // The list of panels listening for events
        subscribers = [];
        // Forces the use of getInstance() or allocTempCart()
        constructor() { }
        static mapTempCarts = {};
        static findOrCreateTempCart(id, bCreateNew) {
            if (!GlobalCart.mapTempCarts.hasOwnProperty(id)) {
                if (bCreateNew)
                    GlobalCart.mapTempCarts[id] = new GlobalCart();
            }
            return GlobalCart.mapTempCarts[id];
        }
        static releaseTempCart(id) {
            delete GlobalCart.mapTempCarts[id];
        }
        static getInstance() {
            if (!GlobalCart.instance) {
                GlobalCart.instance = new GlobalCart();
            }
            return GlobalCart.instance;
        }
        // Panels call this to listen for cart updates.
        subscribeToUpdates(panel, key, callback) {
            this.subscribers = this.subscribers.filter(sub => sub.panel.IsValid());
            // Check if this exact panel is already in the list
            const existingIndex = this.subscribers.findIndex(sub => sub.panel === panel && sub.key === key);
            if (existingIndex !== -1) {
                // Overwrite the old callback with the new one.
                // IsValid() returns true for dynamic lister tiles since they are never destroyed but reused
                this.subscribers[existingIndex].callback = callback;
            }
            else {
                this.subscribers.push({ panel, key, callback });
            }
            // Set initial state
            callback();
        }
        // The cart calls this internally whenever data changes.      
        broadcastUpdate() {
            // Remove any panels that were destroyed 
            this.subscribers = this.subscribers.filter(sub => sub.panel.IsValid());
            // Valid panels update themselves
            for (const sub of this.subscribers) {
                sub.callback();
            }
        }
        calculateTotals() {
            let totalItems = 0;
            let totalPrice = 0;
            for (const item of this.items) {
                totalItems += item.quantity;
                totalPrice += (item.price * item.quantity);
            }
            this.totalItems = totalItems;
            this.totalPrice = totalPrice;
            this.broadcastUpdate();
        }
        // Accessors
        addItem(product, quantity = 1) {
            if (this.totalItems >= 100) {
                return;
            }
            const existingItem = this.items.find(item => item.id === product.id);
            $.Msg('add item - name: ' + product.name);
            if (existingItem) {
                const newQuantity = existingItem.quantity + quantity;
                existingItem.quantity = Math.min(newQuantity, this.MAX_PER_ITEM);
            }
            else {
                const initialQuantity = Math.min(quantity, this.MAX_PER_ITEM);
                this.items.push({ ...product, quantity: initialQuantity });
            }
            this.calculateTotals();
        }
        removeItem(productId) {
            this.items = this.items.filter(item => item.id !== productId);
            this.calculateTotals();
        }
        decrementItem(productId, amount = 1) {
            const item = this.items.find(item => item.id === productId);
            if (item) {
                item.quantity -= amount;
                if (item.quantity <= 0) {
                    // If it hits zero, reuse our existing method to wipe it out entirely
                    this.removeItem(productId);
                }
                else {
                    // Otherwise, just recalculate the new totals
                    this.calculateTotals();
                }
            }
        }
        updateQuantity(productId, quantity) {
            if (quantity <= 0) {
                this.removeItem(productId);
                return;
            }
            const item = this.items.find(item => item.id === productId);
            if (item) {
                item.quantity = Math.min(quantity, this.MAX_PER_ITEM);
                this.calculateTotals();
            }
        }
        getItemQuantity(productId) {
            const item = this.items.find(item => item.id === productId);
            return item ? item.quantity : 0;
        }
        clearCart() {
            this.items = [];
            this.calculateTotals();
        }
        getItems() {
            return this.items;
        }
        getItemUnitPrice(productId) {
            const item = this.items.find(item => item.id === productId);
            return item ? item.price : 0;
        }
        getItemLinePrice(productId) {
            const item = this.items.find(item => item.id === productId);
            return item ? (item.price * item.quantity) : 0;
        }
        getTotalItems() {
            return this.totalItems;
        }
        getTotalPrice() {
            return this.totalPrice;
        }
        //Syncs all items in the cart against the upto date prices incase we update outside cart.
        //Pass in a lookup function that returns the true current price of an itemid.
        syncPrices(getPriceById) {
            let pricesChanged = false;
            for (const item of this.items) {
                const livePrice = getPriceById(item.id);
                // If the price is different from our cached price
                if (livePrice !== undefined && item.price !== undefined) {
                    //Save old price
                    item.oldPrice = item.price;
                    $.Msg('Price in cart Updated: ' + item.name);
                    item.price = livePrice;
                    pricesChanged = item.price !== item.oldPrice;
                }
            }
            // Only recalculate and update if something changed
            if (pricesChanged) {
                this.calculateTotals();
            }
        }
    }
    // Export the single instance globally
    ShoppingCart.cart = GlobalCart.getInstance();
    function findOrCreateTempCart(id, bCreateNew) { return GlobalCart.findOrCreateTempCart(id, bCreateNew); }
    ShoppingCart.findOrCreateTempCart = findOrCreateTempCart;
    function releaseTempCart(id) { GlobalCart.releaseTempCart(id); }
    ShoppingCart.releaseTempCart = releaseTempCart;
})(ShoppingCart || (ShoppingCart = {}));
