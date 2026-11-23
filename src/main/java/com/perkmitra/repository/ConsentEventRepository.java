package com.perkmitra.repository;

import com.perkmitra.entity.ConsentEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ConsentEventRepository extends JpaRepository<ConsentEvent, UUID> {

    List<ConsentEvent> findAllByCustomer_Business_IdAndCustomer_Id(UUID businessId, UUID customerId);

    List<ConsentEvent> findAllByCustomer_Id(UUID customerId);
}
