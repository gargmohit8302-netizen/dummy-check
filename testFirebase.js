require('dotenv').config();
const Admin = require('./models/adminModel');
const bcrypt = require('bcrypt');

async function createTestAdmin() {
    try {
        console.log('Creating test admin...');
        
        const hashedPassword = await bcrypt.hash('admin123', 10);
        
        const admin = new Admin({
            email: 'admin@test.com',
            name: 'Test Admin',
            password: hashedPassword
        });
        
        await admin.save();
        
        console.log('✅ Admin created successfully!');
        console.log('Admin ID:', admin.id);
        console.log('Email:', admin.email);
        console.log('Name:', admin.name);
        console.log('\nNow check Firebase Console -> Firestore Database -> Data tab');
        console.log('You should see "admins" collection with this entry!');
        
        process.exit(0);
    } catch (error) {
        console.error('❌ Error creating admin:', error.message);
        process.exit(1);
    }
}

createTestAdmin();
