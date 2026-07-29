# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Spree::Api::V3::AvailabilityNotifications', type: :request do
  describe 'POST /api/v3/availability_notifications' do
    subject(:create_request) do
      post '/api/v3/availability_notifications',
           params: params,
           as: :json
    end

    let(:email) { 'customer@example.com' }
    let(:variant) { create(:variant, sku: 'SKU-123') }
    let(:variant_options) { { 'size' => 'M', 'color' => 'Black' } }

    let(:params) do
      {
        availability_notification: {
          email: email,
          variant: {
            sku: variant.sku,
            options: variant_options
          }
        }
      }
    end

    context 'with valid params' do
      it 'returns no content' do
        create_request

        expect(response).to have_http_status(:no_content)
      end

      it 'creates an availability notification' do
        expect { create_request }
          .to change(SpreeAvailabilityNotifications::AvailabilityNotification, :count)
          .by(1)
      end

      it 'stores the receiver email' do
        create_request

        notification = SpreeAvailabilityNotifications::AvailabilityNotification.last

        expect(notification.receiver_email).to eq(email)
      end

      it 'stores the variant' do
        create_request

        notification = SpreeAvailabilityNotifications::AvailabilityNotification.last

        expect(notification.variant).to eq(variant)
      end

      it 'stores the variant options' do
        create_request

        notification = SpreeAvailabilityNotifications::AvailabilityNotification.last

        expect(notification.variant_options).to eq(variant_options)
      end
    end

    context 'when variant options are missing' do
      let(:params) do
        {
          availability_notification: {
            email: email,
            variant: {
              sku: variant.sku
            }
          }
        }
      end

      it 'creates an availability notification with empty variant options' do
        create_request

        notification = SpreeAvailabilityNotifications::AvailabilityNotification.last

        expect(response).to have_http_status(:no_content)
        expect(notification.variant_options).to eq({})
      end
    end

    context 'when variant does not exist' do
      let(:missing_sku) { 'MISSING-SKU' }

      let(:params) do
        {
          availability_notification: {
            email: email,
            variant: {
              sku: missing_sku,
              options: variant_options
            }
          }
        }
      end

      it 'returns unprocessable entity' do
        create_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create an availability notification' do
        expect { create_request }
          .not_to change(SpreeAvailabilityNotifications::AvailabilityNotification, :count)
      end

      it 'returns a variant_not_found error' do
        create_request

        json = response.parsed_body

        expect(json).to eq(
          'errors' => [
            {
              'code' => 'variant_not_found',
              'message' => I18n.t(
                'spree.availability_notifications.errors.variant_not_found',
                sku: missing_sku
              )
            }
          ]
        )
      end
    end

    context 'when email is invalid' do
      let(:email) { 'invalid-email' }

      it 'returns unprocessable entity' do
        create_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create an availability notification' do
        expect { create_request }
          .not_to change(SpreeAvailabilityNotifications::AvailabilityNotification, :count)
      end

      it 'returns validation errors' do
        create_request

        json = response.parsed_body

        expect(json['errors']).to include('receiver_email')
        expect(json['errors']['receiver_email'].map(&:downcase)).to include(
          'is not a valid email address'
        )
      end
    end

    context 'when email is missing' do
      let(:params) do
        {
          availability_notification: {
            variant: {
              sku: variant.sku,
              options: variant_options
            }
          }
        }
      end

      it 'returns unprocessable entity' do
        create_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns validation errors' do
        create_request

        json = response.parsed_body

        expect(json['errors']).to include('receiver_email')
        expect(json['errors']['receiver_email']).to include("can't be blank")
      end
    end

    context 'when variant sku is missing' do
      let(:params) do
        {
          availability_notification: {
            email: email,
            variant: {
              options: variant_options
            }
          }
        }
      end

      it 'returns unprocessable entity' do
        create_request

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns a variant_not_found error' do
        create_request

        json = response.parsed_body

        expect(json['errors']).to eq(
          [
            {
              'code' => 'variant_not_found',
              'message' => I18n.t(
                'spree.availability_notifications.errors.variant_not_found',
                sku: nil
              )
            }
          ]
        )
      end
    end
  end
end
