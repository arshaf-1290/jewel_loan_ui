const express = require('express');
const mysql = require('mysql2');
const multer = require('multer');
const cors = require('cors');

const app = express();

// Settings
app.set('port', process.env.PORT || 3309);

// Middlewares
app.use(express.json());
app.use(cors());

// Configure multer storage
const storage = multer.memoryStorage();
const upload = multer({ storage });

// Database connection
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'jewelry_management',
});

// Connect to MySQL
db.connect((err) => {
  if (err) {
    console.error('❌ Error connecting to MySQL:', err);
  } else {
    console.log('✅ Connected to MySQL');
  }
});


// Example route
app.get('/', (req, res) => {
  res.send('Server running successfully!');
});

app.post('/api/companies', (req, res) => {
  const {
    companyName,
    businessType,
    primaryContactNumber,
    alternateContactNumber,
    businessEmail,
    gstin,
    address,
    city,
    state,
    pinCode,
    invoicePrefix,
    adminUsername,
    accessPin,
    acceptTerms,
  } = req.body;

  const requiredFields = {
    companyName,
    businessType,
    primaryContactNumber,
    address,
    city,
    state,
    pinCode,
    adminUsername,
    accessPin,
  };

  const missingField = Object.entries(requiredFields).find(
    ([, value]) => value === undefined || value === null || String(value).trim() === ''
  );

  if (missingField) {
    return res.status(400).json({
      success: false,
      message: `Missing required field: ${missingField[0]}`,
    });
  }

  if (!acceptTerms) {
    return res.status(400).json({
      success: false,
      message: 'Terms must be accepted before creating a company record.',
    });
  }

  const insertCompanyQuery = `
    INSERT INTO company (
      company_name,
      address,
      city,
      state,
      pincode,
      mobile_no,
      alternative_contact,
      gst_no,
      business_type,
      invoice_prefix,
      email
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const companyValues = [
    companyName.trim(),
    address.trim(),
    city.trim(),
    state.trim(),
    pinCode.trim(),
    primaryContactNumber.trim(),
    alternateContactNumber ? String(alternateContactNumber).trim() : null,
    gstin ? gstin.trim() : null,
    businessType.trim(),
    invoicePrefix ? invoicePrefix.trim() : null,
    businessEmail ? businessEmail.trim() : null,
  ];

  db.beginTransaction((transactionError) => {
    if (transactionError) {
      console.error('❌ Error starting transaction:', transactionError);
      return res.status(500).json({
        success: false,
        message: 'Database transaction failed to start.',
      });
    }

    db.query(insertCompanyQuery, companyValues, (companyError, companyResult) => {
      if (companyError) {
        console.error('❌ Error inserting company:', companyError);
        return db.rollback(() => {
          if (companyError.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({
              success: false,
              message: 'A company with the provided unique fields already exists.',
            });
          }

          return res.status(500).json({
            success: false,
            message: 'Failed to create company. Please try again later.',
          });
        });
      }

      const companyId = companyResult.insertId;

      const insertUserQuery = `
        INSERT INTO users (
          com_id,
          username,
          password,
          role,
          status
        ) VALUES (?, ?, ?, 'Admin', 'Active')
      `;

      const userValues = [
        companyId,
        adminUsername.trim(),
        String(accessPin).trim(),
      ];

      db.query(insertUserQuery, userValues, (userError, userResult) => {
        if (userError) {
          console.error('❌ Error inserting admin user:', userError);
          return db.rollback(() => {
            if (userError.code === 'ER_DUP_ENTRY') {
              return res.status(409).json({
                success: false,
                message: 'An admin account with the provided credentials already exists.',
              });
            }

            return res.status(500).json({
              success: false,
              message: 'Company created but failed to set up admin account.',
            });
          });
        }

        db.commit((commitError) => {
          if (commitError) {
            console.error('❌ Error committing transaction:', commitError);
            return db.rollback(() => {
              return res.status(500).json({
                success: false,
                message: 'Failed to finalise company creation. Please try again.',
              });
            });
          }

          return res.status(201).json({
            success: true,
            message: 'Company created successfully.',
            data: {
              companyId,
              companyName,
              adminUserId: userResult.insertId,
            },
          });
        });
      });
    });
  });
});

// Start the server
app.listen(app.get('port'), () => {
  console.log(`🚀 Server running on port ${app.get('port')}`);
});