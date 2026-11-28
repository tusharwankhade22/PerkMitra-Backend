package com.perkmitra.repository;

import com.perkmitra.entity.Reward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface RewardRepository extends JpaRepository<Reward, UUID> {

    List<Reward> findAllByBusiness_Id(UUID businessId);

    List<Reward> findAllByBusiness_IdAndLoyaltyCard_Id(UUID businessId, UUID loyaltyCardId);

    Optional<Reward> findByIdAndBusiness_Id(UUID rewardId, UUID businessId);

    boolean existsByBusiness_IdAndCodeHash(UUID businessId, String codeHash);
}
