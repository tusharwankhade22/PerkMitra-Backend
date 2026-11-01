
-- =====================================================
-- PerkMitra
-- Migration V5: Create Loyalty Cards and Stamp Events
-- =====================================================

-- LOYALTY CARDS
CREATE TABLE app.loyalty_cards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    campaign_id UUID NOT NULL,
    customer_id UUID NOT NULL,

    stamps_earned INTEGER NOT NULL DEFAULT 0,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',

    issued_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_loyalty_cards_campaign
        FOREIGN KEY (campaign_id, business_id)
        REFERENCES app.campaigns(id, business_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_loyalty_cards_customer
        FOREIGN KEY (customer_id, business_id)
        REFERENCES app.customers(id, business_id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_loyalty_cards_id_business
        UNIQUE (id, business_id),

    CONSTRAINT uk_loyalty_cards_campaign_customer
        UNIQUE (campaign_id, customer_id),

    CONSTRAINT chk_loyalty_cards_stamps
        CHECK (stamps_earned >= 0),

    CONSTRAINT chk_loyalty_cards_status
        CHECK (status IN ('ACTIVE', 'COMPLETED', 'INACTIVE'))
);

CREATE INDEX idx_loyalty_cards_business_customer
    ON app.loyalty_cards (business_id, customer_id);

CREATE INDEX idx_loyalty_cards_business_status
    ON app.loyalty_cards (business_id, status);


-- STAMP EVENTS
CREATE TABLE app.stamp_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    business_id UUID NOT NULL,
    loyalty_card_id UUID NOT NULL,
    branch_id UUID,

    issued_by_user_id UUID NOT NULL,

    event_type VARCHAR(20) NOT NULL,
    stamp_delta INTEGER NOT NULL,

    idempotency_key VARCHAR(150) NOT NULL,
    reason VARCHAR(500),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_stamp_events_loyalty_card
        FOREIGN KEY (loyalty_card_id, business_id)
        REFERENCES app.loyalty_cards(id, business_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_stamp_events_branch
        FOREIGN KEY (branch_id, business_id)
        REFERENCES app.branches(id, business_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_stamp_events_issuer_membership
        FOREIGN KEY (business_id, issued_by_user_id)
        REFERENCES app.business_members(business_id, user_id)
        ON DELETE RESTRICT,

    CONSTRAINT uk_stamp_events_idempotency
        UNIQUE (business_id, idempotency_key),

    CONSTRAINT chk_stamp_events_type
        CHECK (event_type IN ('ISSUED', 'VOIDED', 'ADJUSTED')),

    CONSTRAINT chk_stamp_events_delta
        CHECK (
            (event_type = 'ISSUED' AND stamp_delta > 0)
            OR
            (event_type = 'VOIDED' AND stamp_delta < 0)
            OR
            (event_type = 'ADJUSTED' AND stamp_delta <> 0)
        )
);

CREATE INDEX idx_stamp_events_business_card_created
    ON app.stamp_events (business_id, loyalty_card_id, created_at DESC);

CREATE INDEX idx_stamp_events_business_created
    ON app.stamp_events (business_id, created_at DESC);

CREATE INDEX idx_stamp_events_branch
    ON app.stamp_events (business_id, branch_id);


-- TABLE DOCUMENTATION
COMMENT ON TABLE app.loyalty_cards IS
'Stores digital loyalty cards issued to customers for a business campaign.';

COMMENT ON TABLE app.stamp_events IS
'Append-only history of stamp issuance, voiding and adjustment events.';
