
-- =====================================================
-- PerkMitra
-- Migration V2: Create Users and Businesses
-- =====================================================

-- USERS
CREATE TABLE app.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,

    platform_role VARCHAR(30) NOT NULL DEFAULT 'USER',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_users_platform_role
        CHECK (platform_role IN ('USER', 'PLATFORM_ADMIN')),

    CONSTRAINT chk_users_status
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED'))
);

-- Case-insensitive unique email
CREATE UNIQUE INDEX uk_users_email_lower
    ON app.users (LOWER(email));


-- BUSINESSES
CREATE TABLE app.businesses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(150) NOT NULL,
    slug VARCHAR(180) NOT NULL,
    description TEXT,

    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_businesses_slug UNIQUE (slug),

    CONSTRAINT chk_businesses_status
        CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED'))
);

-- Business lookup index
CREATE INDEX idx_businesses_status
    ON app.businesses (status);


-- Table documentation
COMMENT ON TABLE app.users IS
'Stores platform users and authentication details.';

COMMENT ON TABLE app.businesses IS
'Stores businesses registered on the PerkMitra platform.';
