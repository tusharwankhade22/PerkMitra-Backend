package com.perkmitra.repository;

import com.perkmitra.entity.Campaign;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface CampaignRepository extends JpaRepository<Campaign, UUID> {

    List<Campaign> findAllByBusiness_Id(UUID businessId);

    Optional<Campaign> findByIdAndBusiness_Id(UUID campaignId, UUID businessId);

    boolean existsByBusiness_IdAndStatus(UUID businessId, String status);
}
