
-- =====================================================
-- PerkMitra
-- Migration V4: Create Campaigns and Customers
-- =====================================================

-- CAMPAIGNS
CREATE TABLE app.campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    created_by_membership_id UUID,

    name VARCHAR(150) NOT NULL,
    description TEXT,

    stamps_required INTEGER NOT NULL,
    reward_description VARCHAR(500) NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',

    start_at TIMESTAMPTZ,
    end_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_campaigns_business
        FOREIGN KEY (business_id)
        REFERENCES app.businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_campaigns_creator_membership
        FOREIGN KEY (business_id, created_by_membership_id)
        REFERENCES app.business_members(business_id, id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_campaigns_id_business
        UNIQUE (id, business_id),

    CONSTRAINT chk_campaigns_stamps_required
        CHECK (stamps_required > 0),

    CONSTRAINT chk_campaigns_status
        CHECK (status IN ('DRAFT', 'ACTIVE', 'PAUSED', 'ARCHIVED')),

    CONSTRAINT chk_campaigns_date_range
        CHECK (end_at IS NULL OR start_at IS NULL OR end_at > start_at)
);

-- Only one ACTIVE campaign per business
CREATE UNIQUE INDEX uk_campaigns_one_active_per_business
    ON app.campaigns (business_id)
    WHERE status = 'ACTIVE';

CREATE INDEX idx_campaigns_business_status
    ON app.campaigns (business_id, status);


-- CUSTOMERS
CREATE TABLE app.customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,

    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_customers_business
        FOREIGN KEY (business_id)
        REFERENCES app.businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_customers_id_business
        UNIQUE (id, business_id),

    CONSTRAINT chk_customers_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

CREATE INDEX idx_customers_business_id
    ON app.customers (business_id);

CREATE INDEX idx_customers_business_phone
    ON app.customers (business_id, phone);

CREATE INDEX idx_customers_business_email
    ON app.customers (business_id, email);


-- TABLE DOCUMENTATION
COMMENT ON TABLE app.campaigns IS
'Stores loyalty campaigns configured by businesses.';

COMMENT ON TABLE app.customers IS
'Stores customer profiles scoped to individual businesses.';
