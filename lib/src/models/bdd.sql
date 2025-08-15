-- Table des rôles (Role)
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table des rôles (Role)
CREATE TABLE professional_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    professional_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table des professionnels de santé (Health Professional)
CREATE TABLE professionals (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone VARCHAR(20),
    address TEXT,
    siret_number VARCHAR(20) UNIQUE NOT NULL,
    professional_types_id UUID REFERENCES professional_types(id) ON DELETE SET NULL,
    logo TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);

-- Table des utilisateurs (User)
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password TEXT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    phone2 VARCHAR(20),
    role_id UUID REFERENCES roles(id) ON DELETE SET NULL,
    address TEXT NOT NULL,
    billing_address TEXT,
    city VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    civility VARCHAR(10) CHECK (civility IN ('M.', 'Mme', 'Mlle')),
    is_company BOOLEAN DEFAULT FALSE,
    professional_id UUID REFERENCES professionals(id) ON DELETE SET NULL,
    notes TEXT,
    last_visit_date TIMESTAMP,
    next_visit_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);

-- Table des écuries (Stable)
CREATE TABLE stables (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    owner_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);

-- Table des types d'alimentation (Feed Type)
CREATE TABLE feed_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    feed_name VARCHAR(100) UNIQUE NOT NULL
);

-- Table des couleurs de chevaux (Horse Color)
CREATE TABLE horse_colors (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    color_name VARCHAR(100) UNIQUE NOT NULL
);

-- Table des types d'activité des chevaux (Horse Activity Type)
CREATE TABLE horse_activity_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_name VARCHAR(100) UNIQUE NOT NULL
);

-- Table des races de chevaux (Horse Breed)
CREATE TABLE horse_breeds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    breed_name VARCHAR(100) UNIQUE NOT NULL
);

-- Table des chevaux (Horse)
CREATE TABLE horses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    age INTEGER NOT NULL,
    breed_id UUID REFERENCES horse_breeds(id) ON DELETE SET NULL,
    stable_id UUID REFERENCES stables(id) ON DELETE SET NULL,
    feed_type_id UUID REFERENCES feed_types(id) ON DELETE SET NULL,
    color_id UUID REFERENCES horse_colors(id) ON DELETE SET NULL,
    activity_type_id UUID REFERENCES horse_activity_types(id) ON DELETE SET NULL,
    address TEXT NOT NULL,
    last_visit_date TIMESTAMP,
    next_visit_date TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);

-- Table de liaison entre chevaux et propriétaires (Horse Owners)
CREATE TABLE horse_owners (
    horse_id UUID REFERENCES horses(id) ON DELETE CASCADE,
    owner_id UUID REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (horse_id, owner_id)
);

-- Table des statuts d'événement (Event Status)
CREATE TABLE event_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_status_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table des etats d'événement (Event States)
CREATE TABLE event_states (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_state_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table des événements (Event)
CREATE TABLE events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    event_date TIMESTAMP NOT NULL,
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    address TEXT NOT NULL,
    stable_id UUID REFERENCES stables(id) ON DELETE SET NULL,
    status_id UUID REFERENCES event_statuses(id) ON DELETE SET NULL,
    states_id UUID REFERENCES event_states(id) ON DELETE SET NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    horse_id UUID REFERENCES horses(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);

-- Table des statuts de facture (Invoice Status)
CREATE TABLE invoice_statuses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_status_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table des types de paiement (Payment Type)
CREATE TABLE payment_types (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    payment_type_name VARCHAR(50) UNIQUE NOT NULL
);

-- Table des observations
CREATE TABLE external_observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    observation_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE incisive_observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    observation_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE mucous_observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    observation_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE enamel_observations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    observation_name VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE other_characteristics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    characteristic_name VARCHAR(255) UNIQUE NOT NULL
);

-- Table des factures (Invoice)
CREATE TABLE invoices (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    client_id UUID REFERENCES users(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    horse_id UUID REFERENCES horses(id) ON DELETE SET NULL,
    stable_id UUID REFERENCES stables(id) ON DELETE SET NULL,
    professional_id UUID REFERENCES professionals(id) ON DELETE SET NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    is_paid BOOLEAN DEFAULT FALSE,
    payment_type_id UUID REFERENCES payment_types(id) ON DELETE SET NULL,
    is_company BOOLEAN DEFAULT FALSE,
    billing_address TEXT NOT NULL,
    status_id UUID REFERENCES invoice_statuses(id) ON DELETE SET NULL,
    issue_date TIMESTAMP DEFAULT NOW(),
    next_visit INTEGER NOT NULL,
    due_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);

-- Table des détails de facture (Invoice Details)
CREATE TABLE invoice_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invoice_id UUID REFERENCES invoices(id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    external_observations_id UUID REFERENCES external_observations(id) ON DELETE SET NULL,
    external_note TEXT,
    incisive_observations_id UUID REFERENCES incisive_observations(id) ON DELETE SET NULL,
    incisive_note TEXT,
    mucous_observations_id UUID REFERENCES mucous_observations(id) ON DELETE SET NULL,
    mucous_note TEXT,
    enamel_observations_id UUID REFERENCES enamel_observations(id) ON DELETE SET NULL,
    enamel_note TEXT,
    other_characteristics_id UUID REFERENCES other_characteristics(id) ON DELETE SET NULL,
    other_note TEXT,
    custom_observation TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW() ON UPDATE NOW()
);




