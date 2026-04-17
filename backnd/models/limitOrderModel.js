const { db } = require('../database/firebaseConnect');

class LimitOrder {
    constructor(data) {
        this.id = data.id || null;
        this.status = data.status || 'pending';
        this.instrument_id = data.instrument_id || null;
        this.tradingsymbol = data.tradingsymbol || '';
        this.name = data.name || '';
        this.exchange = data.exchange || '';
        this.price = data.price || 0;
        this.quantity = data.quantity || 0;
        this.lot_size = data.lot_size || 0;
        this.expiry = data.expiry || null;
        this.marginBlocked = data.marginBlocked || 0;
        this.instrument_type = data.instrument_type || '';
        this.order_type = data.order_type || '';
        this.buy_type = data.buy_type || '';
        this.show_type = data.show_type || '';
        this.user = data.user || '';
        this.buy_price = data.buy_price || 0;
        this.createdAt = data.createdAt || new Date();
        this.updatedAt = data.updatedAt || new Date();
    }

    static getCollection() {
        return db.collection('limit_orders');
    }

    async save() {
        this.updatedAt = new Date();
        const orderData = {
            status: this.status,
            instrument_id: this.instrument_id,
            tradingsymbol: this.tradingsymbol,
            name: this.name,
            exchange: this.exchange,
            price: this.price,
            quantity: this.quantity,
            lot_size: this.lot_size,
            expiry: this.expiry,
            marginBlocked: this.marginBlocked,
            instrument_type: this.instrument_type,
            order_type: this.order_type,
            buy_type: this.buy_type,
            show_type: this.show_type,
            user: this.user,
            buy_price: this.buy_price,
            updatedAt: this.updatedAt
        };

        if (this.id) {
            await LimitOrder.getCollection().doc(this.id).update(orderData);
            return this;
        } else {
            orderData.createdAt = this.createdAt;
            const docRef = await LimitOrder.getCollection().add(orderData);
            this.id = docRef.id;
            return this;
        }
    }

    static async findById(id) {
        const doc = await LimitOrder.getCollection().doc(id).get();
        if (!doc.exists) return null;
        return new LimitOrder({ id: doc.id, ...doc.data() });
    }

    static async findOne(query) {
        let queryRef = LimitOrder.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            if (key === '_id') {
                // Handle _id as document ID
                const doc = await LimitOrder.getCollection().doc(value).get();
                if (!doc.exists) return null;
                const order = new LimitOrder({ id: doc.id, ...doc.data() });
                // Check other query conditions
                const otherKeys = Object.keys(query).filter(k => k !== '_id');
                for (const k of otherKeys) {
                    if (order[k] !== query[k]) return null;
                }
                return order;
            }
            queryRef = queryRef.where(key, '==', value);
        }
        
        const snapshot = await queryRef.limit(1).get();
        if (snapshot.empty) return null;
        
        const doc = snapshot.docs[0];
        return new LimitOrder({ id: doc.id, ...doc.data() });
    }

    static async find(query = {}) {
        let queryRef = LimitOrder.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            queryRef = queryRef.where(key, '==', value);
        }
        
        const snapshot = await queryRef.get();
        return snapshot.docs.map(doc => new LimitOrder({ id: doc.id, ...doc.data() }));
    }

    static async deleteMany(query) {
        const orders = await LimitOrder.find(query);
        const batch = db.batch();
        
        orders.forEach(order => {
            batch.delete(LimitOrder.getCollection().doc(order.id));
        });
        
        await batch.commit();
        return { deletedCount: orders.length };
    }

    static async updateOne(query, update) {
        const order = await LimitOrder.findOne(query);
        if (!order) return { modifiedCount: 0 };
        
        const updateData = update.$set || update;
        Object.assign(order, updateData);
        await order.save();
        
        return { modifiedCount: 1 };
    }

    static async findOneAndUpdate(query, update, options = {}) {
        const order = await LimitOrder.findOne(query);
        if (!order) return null;
        
        const updateData = update.$set || update;
        Object.assign(order, updateData);
        await order.save();
        
        return order;
    }

    static async updateMany(query, update) {
        const orders = await LimitOrder.find(query);
        if (orders.length === 0) return { modifiedCount: 0 };
        
        const updateData = update.$set || update;
        const batch = db.batch();
        
        orders.forEach(order => {
            Object.assign(order, updateData);
            const orderData = {
                status: order.status,
                instrument_id: order.instrument_id,
                tradingsymbol: order.tradingsymbol,
                name: order.name,
                exchange: order.exchange,
                price: order.price,
                quantity: order.quantity,
                lot_size: order.lot_size,
                expiry: order.expiry,
                marginBlocked: order.marginBlocked,
                instrument_type: order.instrument_type,
                order_type: order.order_type,
                buy_type: order.buy_type,
                show_type: order.show_type,
                user: order.user,
                buy_price: order.buy_price,
                updatedAt: new Date()
            };
            batch.update(LimitOrder.getCollection().doc(order.id), orderData);
        });
        
        await batch.commit();
        return { modifiedCount: orders.length };
    }
}

module.exports = LimitOrder;


  
  

