
-- =====================================================
-- PerkMitra
-- Migration V3: Create Branches and Business Members
-- =====================================================


CREATE TABLE app.branches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    name VARCHAR(150) NOT NULL,
    address TEXT,
    contact_phone VARCHAR(20),

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_branches_business
        FOREIGN KEY (business_id)
        REFERENCES app.businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_branches_status
        CHECK (status IN ('ACTIVE', 'INACTIVE')),

    CONSTRAINT uk_branches_id_business
        UNIQUE (id, business_id)
);

CREATE INDEX idx_branches_business_id
    ON app.branches (business_id);


CREATE TABLE app.business_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    user_id UUID NOT NULL,

    role VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_business_members_business
        FOREIGN KEY (business_id)
        REFERENCES app.businesses(id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_business_members_user
        FOREIGN KEY (user_id)
        REFERENCES app.users(id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_business_members_business_user
        UNIQUE (business_id, user_id),

    CONSTRAINT uk_business_members_business_id
        UNIQUE (business_id, id),
        
    CONSTRAINT uk_business_members_business_id_user
       UNIQUE (business_id, id, user_id),

    CONSTRAINT chk_business_members_role
        CHECK (role IN ('BUSINESS_OWNER', 'STAFF')),

    CONSTRAINT chk_business_members_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))

);

CREATE INDEX idx_business_members_user_id
    ON app.business_members (user_id);

CREATE INDEX idx_business_members_business_status
    ON app.business_members (business_id, status);


-- TABLE DOCUMENTATION
COMMENT ON TABLE app.branches IS
'Stores individual branches belonging to a registered business.';

COMMENT ON TABLE app.business_members IS
'Maps platform users to businesses with business-specific roles.';
