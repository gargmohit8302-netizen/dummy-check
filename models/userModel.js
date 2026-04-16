const { db } = require('../database/firebaseConnect');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

class User {
    constructor(data) {
        this.id = data.id || null;
        this.email = data.email || '';
        this.name = data.name || '';
        this.password = data.password || '';
        this.token = data.token || '';
        this.role = data.role || '';
        this.isBlocked = data.isBlocked || 'init';
        this.walletBalance = data.walletBalance || 0;
        this.trade_limit = data.trade_limit || 3;
        this.createdAt = data.createdAt || new Date();
        this.updatedAt = data.updatedAt || new Date();
    }

    static getCollection() {
        return db.collection('users');
    }

    async save() {
        this.updatedAt = new Date();
        const userData = {
            email: this.email.toLowerCase().trim(),
            name: this.name.trim(),
            password: this.password,
            token: this.token,
            role: this.role,
            isBlocked: this.isBlocked,
            walletBalance: this.walletBalance,
            trade_limit: this.trade_limit,
            updatedAt: this.updatedAt
        };

        if (this.id) {
            await User.getCollection().doc(this.id).update(userData);
            return this;
        } else {
            userData.createdAt = this.createdAt;
            const docRef = await User.getCollection().add(userData);
            this.id = docRef.id;
            return this;
        }
    }

    static async findById(id) {
        const doc = await User.getCollection().doc(id).get();
        if (!doc.exists) return null;
        return new User({ id: doc.id, ...doc.data() });
    }

    static async findOne(query) {
        let queryRef = User.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            if (key === 'email') {
                queryRef = queryRef.where(key, '==', value.toLowerCase());
            } else {
                queryRef = queryRef.where(key, '==', value);
            }
        }
        
        const snapshot = await queryRef.limit(1).get();
        if (snapshot.empty) return null;
        
        const doc = snapshot.docs[0];
        return new User({ id: doc.id, ...doc.data() });
    }

    static async find(query = {}) {
        let queryRef = User.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            queryRef = queryRef.where(key, '==', value);
        }
        
        const snapshot = await queryRef.get();
        return snapshot.docs.map(doc => new User({ id: doc.id, ...doc.data() }));
    }

    static async deleteOne(query) {
        const user = await User.findOne(query);
        if (user) {
            await User.getCollection().doc(user.id).delete();
            return { deletedCount: 1 };
        }
        return { deletedCount: 0 };
    }

    generateToken() {
        return jwt.sign(
            {
                _id: this.id,
                email: this.email,
                role: this.role,
            },
            process.env.TOKEN_SECRET
        );
    }

    toJSON1() {
        return {
            _id: this.id,
            email: this.email,
            name: this.name,
            token: this.token,
        };
    }
}

module.exports = User;



