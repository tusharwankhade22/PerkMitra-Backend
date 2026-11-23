
package com.perkmitra.repository;

import com.perkmitra.entity.StampEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface StampEventRepository
        extends JpaRepository<StampEvent, UUID> {

    List<StampEvent> findAllByBusiness_Id(UUID businessId);

    List<StampEvent> findAllByBusiness_IdAndLoyaltyCard_Id(
            UUID businessId,
            UUID loyaltyCardId);

    List<StampEvent> findAllByBusiness_IdAndIssuedByUser_Id(
            UUID businessId,
            UUID userId);

    Optional<StampEvent> findByIdAndBusiness_Id(
            UUID stampEventId,
            UUID businessId);
}
