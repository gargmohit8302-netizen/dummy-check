const { db } = require('../database/firebaseConnect');

class WalletTransaction {
    constructor(data) {
        this.id = data.id || null;
        this.type = data.type || '';
        this.instrument_id = data.instrument_id || null;
        this.tradingsymbol = data.tradingsymbol || '';
        this.exchange = data.exchange || '';
        this.name = data.name || '';
        this.amount = data.amount || 0;
        this.description = data.description || '';
        this.user = data.user || '';
        this.admin = data.admin || '';
        this.trade_id = data.trade_id || '';
        this.createdAt = data.createdAt || new Date();
        this.updatedAt = data.updatedAt || new Date();
    }

    static getCollection() {
        return db.collection('wallet_transactions');
    }

    async save() {
        this.updatedAt = new Date();
        const walletData = {
            type: this.type,
            instrument_id: this.instrument_id,
            tradingsymbol: this.tradingsymbol,
            exchange: this.exchange,
            name: this.name,
            amount: this.amount,
            description: this.description,
            user: this.user,
            admin: this.admin,
            trade_id: this.trade_id,
            updatedAt: this.updatedAt
        };

        if (this.id) {
            await WalletTransaction.getCollection().doc(this.id).update(walletData);
            return this;
        } else {
            walletData.createdAt = this.createdAt;
            const docRef = await WalletTransaction.getCollection().add(walletData);
            this.id = docRef.id;
            return this;
        }
    }

    static async findById(id) {
        const doc = await WalletTransaction.getCollection().doc(id).get();
        if (!doc.exists) return null;
        return new WalletTransaction({ id: doc.id, ...doc.data() });
    }

    static async findOne(query) {
        let queryRef = WalletTransaction.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            queryRef = queryRef.where(key, '==', value);
        }
        
        const snapshot = await queryRef.limit(1).get();
        if (snapshot.empty) return null;
        
        const doc = snapshot.docs[0];
        return new WalletTransaction({ id: doc.id, ...doc.data() });
    }

    static async find(query = {}) {
        let queryRef = WalletTransaction.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            queryRef = queryRef.where(key, '==', value);
        }
        
        const snapshot = await queryRef.get();
        return snapshot.docs.map(doc => new WalletTransaction({ id: doc.id, ...doc.data() }));
    }

    static async deleteMany(query) {
        const transactions = await WalletTransaction.find(query);
        const batch = db.batch();
        
        transactions.forEach(transaction => {
            batch.delete(WalletTransaction.getCollection().doc(transaction.id));
        });
        
        await batch.commit();
        return { deletedCount: transactions.length };
    }

    static async findWithSort(query = {}, sortField = 'createdAt', sortOrder = 'desc') {
        let queryRef = WalletTransaction.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            queryRef = queryRef.where(key, '==', value);
        }
        
        queryRef = queryRef.orderBy(sortField, sortOrder);
        const snapshot = await queryRef.get();
        return snapshot.docs.map(doc => new WalletTransaction({ id: doc.id, ...doc.data() }));
    }
}

module.exports = WalletTransaction;
  

