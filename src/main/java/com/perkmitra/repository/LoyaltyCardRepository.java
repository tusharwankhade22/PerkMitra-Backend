
package com.perkmitra.repository;

import com.perkmitra.entity.LoyaltyCard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface LoyaltyCardRepository extends JpaRepository<LoyaltyCard, UUID> {

    List<LoyaltyCard> findAllByBusiness_Id(UUID businessId);

    List<LoyaltyCard> findAllByBusiness_IdAndCustomerId(UUID businessId, UUID customerId);

    List<LoyaltyCard> findAllByBusiness_IdAndCampaignId(UUID businessId, UUID campaignId);

    Optional<LoyaltyCard> findByIdAndBusiness_Id(UUID loyaltyCardId, UUID businessId);
}
