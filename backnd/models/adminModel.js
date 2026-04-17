const { db } = require('../database/firebaseConnect');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

class Admin {
    constructor(data) {
        this.id = data.id || null;
        this.email = data.email || '';
        this.password = data.password || '';
        this.name = data.name || '';
        this.token = data.token || '';
        this.createdAt = data.createdAt || new Date();
        this.updatedAt = data.updatedAt || new Date();
        this._isPasswordModified = false;
    }

    static getCollection() {
        return db.collection('admins');
    }

    isModified(field) {
        if (field === 'password') {
            return this._isPasswordModified;
        }
        return false;
    }

    async save() {
        this.updatedAt = new Date();
        
        if (this._isPasswordModified) {
            this.password = await bcrypt.hash(this.password, 10);
        }

        const adminData = {
            email: this.email.toLowerCase().trim(),
            password: this.password,
            name: this.name.trim(),
            token: this.token,
            updatedAt: this.updatedAt
        };

        if (this.id) {
            await Admin.getCollection().doc(this.id).update(adminData);
            return this;
        } else {
            adminData.createdAt = this.createdAt;
            const docRef = await Admin.getCollection().add(adminData);
            this.id = docRef.id;
            return this;
        }
    }

    static async findById(id) {
        const doc = await Admin.getCollection().doc(id).get();
        if (!doc.exists) return null;
        return new Admin({ id: doc.id, ...doc.data() });
    }

    static async findOne(query) {
        let queryRef = Admin.getCollection();
        
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
        return new Admin({ id: doc.id, ...doc.data() });
    }

    static async find(query = {}) {
        let queryRef = Admin.getCollection();
        
        for (const [key, value] of Object.entries(query)) {
            queryRef = queryRef.where(key, '==', value);
        }
        
        const snapshot = await queryRef.get();
        return snapshot.docs.map(doc => new Admin({ id: doc.id, ...doc.data() }));
    }

    async isPasswordCorrect(password) {
        return await bcrypt.compare(password, this.password);
    }

    generateToken() {
        return jwt.sign(
            {
                _id: this.id,
                email: this.email,
            },
            process.env.TOKEN_SECRET
        );
    }

    toJSON1() {
        return {
            _id: this.id,
            email: this.email,
            name: this.name,
            token: this.token
        };
    }
}

module.exports = Admin;



